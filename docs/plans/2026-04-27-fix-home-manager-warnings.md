# Fix Home-Manager Evaluation Warnings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Silence the three home-manager evaluation warnings that appear on `make switch` by explicitly setting the options that changed defaults in 26.05.

**Architecture:** Three targeted one-liner additions to two existing module files. No file creation needed. Firefox task includes a data migration step (moving the profile directory on disk) to adopt the new XDG path.

**Tech Stack:** Nix / home-manager

---

## Files

- Modify: `user_modules/neovim.nix` — add `withRuby` and `withPython3` options
- Modify: `user_modules/browsers.nix` — add `programs.firefox.configPath`

---

### Task 1: Silence neovim Ruby and Python3 warnings

The new home-manager default for `withRuby` and `withPython3` is `false`. We adopt the new defaults (no Ruby/Python3 support needed for this config).

**Files:**
- Modify: `user_modules/neovim.nix`

- [ ] **Step 1: Add the two options to the neovim block**

Edit `user_modules/neovim.nix` so `programs.neovim` reads:

```nix
programs.neovim = {
  enable = true;
  defaultEditor = true;
  withRuby = false;
  withPython3 = false;
  extraPackages = with pkgs; [ gnumake gcc tree-sitter ];
};
```

- [ ] **Step 2: Verify no syntax errors**

```bash
nix-instantiate --parse user_modules/neovim.nix
```

Expected: prints the parsed expression with no errors.

- [ ] **Step 3: Commit**

```bash
git add user_modules/neovim.nix
git commit -m "fix: adopt new neovim withRuby/withPython3 defaults (false)"
```

---

### Task 2: Silence the Firefox configPath warning

The new home-manager default moves Firefox's profile directory from `~/.mozilla/firefox` to `$XDG_CONFIG_HOME/mozilla/firefox` (i.e. `~/.config/mozilla/firefox`). We adopt the new default and migrate the existing profile on disk.

**Files:**
- Modify: `user_modules/browsers.nix`

- [ ] **Step 1: Add configPath to browsers.nix**

Edit `user_modules/browsers.nix` so it reads:

```nix
{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.brave
    pkgs.chromium
  ];

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}
```

> **Note:** `config.xdg.configHome` resolves to `~/.config` at evaluation time.

- [ ] **Step 2: Verify no syntax errors**

```bash
nix-instantiate --parse user_modules/browsers.nix
```

Expected: prints the parsed expression with no errors.

- [ ] **Step 3: Commit the config change**

```bash
git add user_modules/browsers.nix
git commit -m "fix: adopt new firefox XDG configPath default"
```

- [ ] **Step 4: Migrate the Firefox profile directory on disk**

> **Do this BEFORE running `make switch`** so Firefox can still find its profile.

```bash
mkdir -p ~/.config/mozilla
mv ~/.mozilla/firefox ~/.config/mozilla/firefox
# Optional: remove the now-empty parent
rmdir ~/.mozilla 2>/dev/null || true
```

Expected: `~/.config/mozilla/firefox` exists and contains your profiles.

- [ ] **Step 5: Rebuild**

Tell the user to run:

```bash
make switch
```

Expected: no evaluation warnings about `withRuby`, `withPython3`, or `configPath`.

---

## Verification

After `make switch` completes, confirm all three warnings are gone:

```bash
sudo nixos-rebuild switch --flake .#karpalo 2>&1 | grep "evaluation warning"
```

Expected: no output (zero warnings).
