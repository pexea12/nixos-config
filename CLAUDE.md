# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using flakes and home-manager. The configuration is for a system named "karpalo" (hostname) with user "pexea12". It uses Hyprland as the window manager on Wayland with various desktop environment components.

## Architecture

### Flake-based Configuration

The repository uses Nix flakes with the following structure:

- **flake.nix**: Entry point defining nixosConfigurations.karpalo and integrating home-manager as a NixOS module
- **configuration.nix**: System-level NixOS configuration (imports hardware-configuration.nix)
- **home.nix**: User-level home-manager configuration for user pexea12 (imports modules from modules/)
- **hardware-configuration.nix**: Auto-generated hardware configuration (AMD CPU, NVME, Thunderbolt)
- **modules/**: Modular home-manager configurations for different components

### Module System

All modules in `modules/` are imported by `home.nix`. The configDir variable is defined in home.nix and passed to modules via `_module.args` to enable consistent config file paths.

### Configuration Files Location

Application configs are stored in `config/` directory and symlinked using `xdg.configFile` with `mkOutOfStoreSymlink`:


The pattern used is:
```nix
xdg.configFile."<name>" = {
  source = config.lib.file.mkOutOfStoreSymlink "${configDir}/<name>";
};
```

This allows editing config files directly without rebuilding.

## Common Commands

### Building and Switching Configuration

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#karpalo

# Build without switching (test configuration)
sudo nixos-rebuild build --flake .#karpalo

# Test configuration (switch but don't set as boot default)
sudo nixos-rebuild test --flake .#karpalo
```

### Updating Dependencies

```bash
# Update flake.lock (all inputs)
nix flake update

# Update specific input only
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
```

### Garbage Collection

```bash
# Manual garbage collection
nix-collect-garbage -d

# System-level garbage collection
sudo nix-collect-garbage -d

# Remove old generations older than 7 days
nix-collect-garbage --delete-older-than 7d
```

Note: Automatic garbage collection is configured to run weekly via configuration.nix:122.

### Testing Configuration Changes

```bash
# Check flake for errors
nix flake check

# Show flake outputs
nix flake show

# Evaluate configuration without building
nixos-rebuild dry-build --flake .#karpalo
```

## Development Workflow

### Adding New Packages

**System-wide packages**: Add to `configuration.nix` in `environment.systemPackages`

**User packages**: Add to `home.nix` in `home.packages`

### Creating New Modules

1. Create file in `modules/<name>.nix`
2. Import in `home.nix` imports list
3. If module needs configDir, add `configDir` to function parameters
4. Follow existing module pattern (see modules/waybar.nix as minimal example)

### Modifying Application Configs

For applications using mkOutOfStoreSymlink (hyprland, waybar):
- Edit files directly in `config/` directory
- Changes take effect immediately without rebuild
- To add new config: create in config/, then symlink in corresponding module

## Important Notes

- **Username/hostname hardcoded**: "pexea12" and "karpalo" are hardcoded (see TODOs in flake.nix:38 and home.nix:67)
- **configDir pattern**: Always use `${configDir}/<dir>` when symlinking configs in modules
- **Unfree packages**: Enabled via nixpkgs.config.allowUnfree in flake.nix:22
- **Experimental features**: nix-command and flakes enabled in configuration.nix:104
- **Brave browser**: Has workaround for Wayland color management bug (revisit after 2025.10.31)
- **Auto-upgrade**: System automatically upgrades weekly without reboot (configuration.nix:108-112)
