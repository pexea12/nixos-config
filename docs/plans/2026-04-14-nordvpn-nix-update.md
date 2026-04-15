# NordVPN nix-update Integration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make NordVPN upgradeable via `nix-update nordvpn` by extracting it into a standalone package file and exposing it as a flake output.

**Architecture:** Extract the inline nordvpn derivation from `system_modules/nordvpn.nix` into `packages/nordvpn.nix`. Expose it under `packages.x86_64-linux.nordvpn` in `flake.nix`. The system module imports the package from `pkgs` overlay or directly via the flake's `self.packages`. `nix-update` targets the flake package attribute to update version + hash in one command.

**Tech Stack:** Nix flakes, nix-update (nixpkgs tool), stdenv, autoPatchelfHook, buildFHSEnvChroot

---

### Task 1: Extract nordvpn derivation to standalone package file

**Files:**
- Create: `packages/nordvpn.nix`
- Modify: `system_modules/nordvpn.nix`

- [ ] **Step 1: Create `packages/nordvpn.nix`**

Extract the derivation out of the module. The file must be a callable Nix function (suitable for `pkgs.callPackage`):

```nix
{
  autoPatchelfHook,
  buildFHSEnvChroot,
  dpkg,
  fetchurl,
  lib,
  stdenv,
  sysctl,
  iptables,
  iproute2,
  procps,
  cacert,
  libxml2,
  libidn2,
  zlib,
  wireguard-tools,
}: let
  pname = "nordvpn";
  version = "4.5.0";

  nordVPNBase = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/n/nordvpn/nordvpn_${version}_amd64.deb";
      hash = "sha256-bekJOzhLGwFsYRuPagANwUduyCufaU4XoJPwWoBniR8=";
    };

    buildInputs = [ libxml2 libidn2 ];
    nativeBuildInputs = [ dpkg autoPatchelfHook stdenv.cc.cc.lib ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      mv usr/* $out/
      mv var/ $out/
      mv etc/ $out/
      runHook postInstall
    '';
  };

  nordVPNfhs = buildFHSEnvChroot {
    name = "nordvpnd";
    runScript = "nordvpnd";

    targetPkgs = pkgs: [
      nordVPNBase
      sysctl
      iptables
      iproute2
      procps
      cacert
      libxml2
      libidn2
      zlib
      wireguard-tools
    ];
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      ln -s ${nordVPNBase}/bin/nordvpn $out/bin
      ln -s ${nordVPNfhs}/bin/nordvpnd $out/bin
      ln -s ${nordVPNBase}/share/* $out/share/
      ln -s ${nordVPNBase}/var $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "CLI client for NordVPN";
      homepage = "https://www.nordvpn.com";
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ];
    };
  }
```

- [ ] **Step 2: Simplify `system_modules/nordvpn.nix` to use `pkgs.nordvpn`**

Replace the entire inline derivation with a reference to `pkgs.nordvpn` (which will be wired up in Task 2):

```nix
{ pkgs, ... }: let
  nordVpnPkg = pkgs.nordvpn;
in {
  environment.systemPackages = [ nordVpnPkg ];

  networking.firewall = {
    checkReversePath = false;
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 1194 ];
  };

  users.groups.nordvpn = {};

  systemd.services.nordvpn = {
    description = "NordVPN daemon.";
    serviceConfig = {
      ExecStart = "${nordVpnPkg}/bin/nordvpnd";
      ExecStartPre = pkgs.writeShellScript "nordvpn-start" ''
        mkdir -m 700 -p /var/lib/nordvpn;
        if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
          cp -r ${nordVpnPkg}/var/lib/nordvpn/* /var/lib/nordvpn;
        fi
      '';
      NonBlocking = true;
      KillMode = "process";
      Restart = "on-failure";
      RestartSec = 5;
      RuntimeDirectory = "nordvpn";
      RuntimeDirectoryMode = "0750";
      Group = "nordvpn";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
```

- [ ] **Step 3: Commit**

```bash
git add packages/nordvpn.nix system_modules/nordvpn.nix
git commit -m "refactor: extract nordvpn derivation to packages/nordvpn.nix"
```

---

### Task 2: Expose nordvpn as a flake output and wire into nixpkgs overlay

**Files:**
- Modify: `flake.nix`

`nix-update` needs to find the package at a flake output path like `.#nordvpn` or `.#packages.x86_64-linux.nordvpn`. The cleanest way to also make it available as `pkgs.nordvpn` inside the NixOS config is via a nixpkgs overlay.

- [ ] **Step 1: Update `flake.nix`**

Add an overlay that injects `nordvpn` into pkgs, and expose it as a `packages` output:

```nix
{
  description = "Nix Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlay = final: prev: {
        nordvpn = final.callPackage ./packages/nordvpn.nix {};
      };
    in {
      packages.${system}.nordvpn = pkgs.extend overlay pkgs.nordvpn;

      nixosConfigurations = {
        karpalo = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            { nixpkgs.config.allowUnfree = true; }
            { nixpkgs.overlays = [ overlay ]; }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.pexea12 = {
                  imports = [ ./home.nix ];
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
  # TODO: use variable for pexea12 and karpalo
}
```

- [ ] **Step 2: Verify the flake evaluates**

```bash
nix flake check
```

Expected: no errors (warnings about dirty tree are fine).

- [ ] **Step 3: Verify the package attribute is reachable**

```bash
nix eval .#packages.x86_64-linux.nordvpn.version
```

Expected output: `"4.5.0"`

- [ ] **Step 4: Commit**

```bash
git add flake.nix
git commit -m "feat: expose nordvpn as flake package output via overlay"
```

---

### Task 3: Add nix-update to dev tools and document upgrade workflow

**Files:**
- Modify: `home.nix` (or whichever module manages dev packages — check `home.packages`)

- [ ] **Step 1: Add `nix-update` to user packages**

Find the `home.packages` list in `home.nix` and add `pkgs.nix-update`:

```nix
home.packages = with pkgs; [
  # ... existing packages ...
  nix-update
];
```

- [ ] **Step 2: Verify `nix-update` is available after rebuild**

Tell the user to run `make switch` and then:

```bash
nix-update --version
```

Expected: prints a version string like `nix-update 1.x.x`.

- [ ] **Step 3: Test the upgrade workflow**

Run `nix-update` targeting the flake package (dry run first):

```bash
nix-update nordvpn --flake --dry-run
```

Expected: prints the current version (4.5.0) and the latest version found, without modifying any files.

When ready to actually upgrade:

```bash
nix-update nordvpn --flake
```

Expected: updates `version` and `hash` fields in `packages/nordvpn.nix` in place.

- [ ] **Step 4: Commit**

```bash
git add home.nix
git commit -m "feat: add nix-update to user packages for nordvpn upgrades"
```
