{
  description = "Nix Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    googleworkspace-cli = {
      url = "github:googleworkspace/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, googleworkspace-cli, ... }:
    let
      system = "x86_64-linux";
      overlay = final: prev: {
        nordvpn = final.callPackage ./packages/nordvpn.nix {};
        gws = googleworkspace-cli.packages.${final.system}.default;
      };
      pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
    in {
      packages.${system}.nordvpn = pkgs.nordvpn;
      nixosConfigurations = {
        karpalo = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              # Temporary for logseq-0.10.15; revisit after 2026-08-26 to check
              # whether Logseq in nixpkgs has moved off EOL Electron 39.
              nixpkgs.config.permittedInsecurePackages = [
                "electron-39.8.10"
              ];
            }
            {
              nixpkgs.overlays = [ overlay ];
            }
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
