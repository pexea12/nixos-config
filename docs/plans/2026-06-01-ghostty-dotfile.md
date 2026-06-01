# Ghostty Dotfile Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track the existing Ghostty config in this repository and manage it through Home Manager like the other dotfiles.

**Architecture:** Copy only the active Ghostty config from `~/.config/ghostty/config` into `config/ghostty/config`. Add a focused `user_modules/ghostty.nix` module that symlinks `${configDir}/ghostty` to `~/.config/ghostty`, then import that module from `home.nix`.

**Tech Stack:** Nix flakes, Home Manager, `xdg.configFile`, `config.lib.file.mkOutOfStoreSymlink`, Ghostty.

---

## File Structure

- Create: `config/ghostty/config`
  - Repository-tracked copy of `/home/pexea12/.config/ghostty/config`.
  - Do not copy backup files such as `config.*.bak`.
- Create: `user_modules/ghostty.nix`
  - Home Manager module responsible only for Ghostty config symlinking.
- Modify: `home.nix`
  - Import `./user_modules/ghostty.nix` in the apps section.
- Leave unchanged: `configuration.nix`
  - `ghostty` is already installed in `environment.systemPackages`.

## Current Workspace Safety

There are unrelated uncommitted changes at the time this plan was written:

- `config/tmux/tmux.conf`
- `user_modules/agentic-coding.nix`

Do not modify, stage, or commit those files while implementing this plan.

---

### Task 1: Copy the active Ghostty config into tracked dotfiles

**Files:**
- Create: `config/ghostty/config`

- [ ] **Step 1: Create the tracked Ghostty config directory**

Run:

```bash
mkdir -p config/ghostty
```

Expected: command exits with status `0`.

- [ ] **Step 2: Copy only the active Ghostty config**

Run:

```bash
cp /home/pexea12/.config/ghostty/config config/ghostty/config
```

Expected: command exits with status `0` and does not copy `config.*.bak` files.

- [ ] **Step 3: Verify the copied config exists**

Run:

```bash
test -f config/ghostty/config && diff -u /home/pexea12/.config/ghostty/config config/ghostty/config
```

Expected: command exits with status `0` and prints no diff.

- [ ] **Step 4: Commit the copied config**

Run:

```bash
git add config/ghostty/config
git commit -m "feat: track ghostty config"
```

Expected: commit includes only `config/ghostty/config`.

---

### Task 2: Add the Ghostty Home Manager module

**Files:**
- Create: `user_modules/ghostty.nix`

- [ ] **Step 1: Create `user_modules/ghostty.nix`**

Write this exact file:

```nix
{ config, configDir, ... }:

{
  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ghostty";
  };
}
```

- [ ] **Step 2: Verify the module syntax parses**

Run:

```bash
nix-instantiate --parse user_modules/ghostty.nix >/dev/null
```

Expected: command exits with status `0`.

- [ ] **Step 3: Commit the module**

Run:

```bash
git add user_modules/ghostty.nix
git commit -m "feat: add ghostty home-manager module"
```

Expected: commit includes only `user_modules/ghostty.nix`.

---

### Task 3: Import the Ghostty module from Home Manager

**Files:**
- Modify: `home.nix`

- [ ] **Step 1: Add the module import in `home.nix`**

In the `imports = [` list, add Ghostty near the other app modules:

```nix
    ./user_modules/zed.nix
    ./user_modules/ghostty.nix
    ./user_modules/agentic-coding.nix
```

- [ ] **Step 2: Verify `home.nix` parses**

Run:

```bash
nix-instantiate --parse home.nix >/dev/null
```

Expected: command exits with status `0`.

- [ ] **Step 3: Verify flake evaluation**

Run:

```bash
nix flake check
```

Expected: command exits with status `0`.

- [ ] **Step 4: Commit the import**

Run:

```bash
git add home.nix
git commit -m "feat: enable ghostty config symlink"
```

Expected: commit includes only `home.nix`.

---

### Task 4: Final manual activation and verification

**Files:**
- No repository file changes.

- [ ] **Step 1: Ask the user to switch the NixOS configuration**

Tell the user to run:

```bash
make switch
```

Expected: user runs the command manually. Do not run this command as the coding agent because it requires sudo.

- [ ] **Step 2: Verify the Ghostty config symlink after activation**

After the user has run `make switch`, run:

```bash
readlink -f /home/pexea12/.config/ghostty
```

Expected output:

```text
/home/pexea12/nixos-config/config/ghostty
```

- [ ] **Step 3: Verify Ghostty can read the tracked config**

Run:

```bash
ghostty +show-config | head -20
```

Expected: command exits with status `0` and prints Ghostty configuration output.

---

## Self-Review

- Spec coverage: The plan copies the existing config, creates `user_modules/ghostty.nix`, imports it from `home.nix`, leaves existing Ghostty installation unchanged, and includes verification.
- Placeholder scan: No placeholder steps or deferred implementation details remain.
- Type consistency: Paths and module names are consistent across all tasks.
