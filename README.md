# NixOS Configuration

Personal NixOS configuration for **karpalo** using flakes and home-manager.

## System

| **WM** | i3 (X11) |
| **Shell** | zsh (prezto) |
| **Terminal** | ghostty |
| **Bar** | polybar |
| **Launcher** | rofi |
| **Notifications** | dunst |
| **Compositor** | picom |

## Structure

```
nixos-config/
├── flake.nix                  # Flake entry point (nixpkgs unstable + home-manager)
├── configuration.nix          # System-level configuration
├── home.nix                   # User-level home-manager configuration
├── hardware-configuration.nix # Auto-generated hardware config
├── user_modules/              # Home-manager modules (fonts, shell, i3, polybar, …)
├── system_modules/            # System modules (input, tailscale, power)
└── config/                    # Application config files (symlinked via mkOutOfStoreSymlink)
    ├── i3/
    ├── tmux/
    ├── polybar/
    ├── rofi/
    ├── dunst/
    └── picom/
```

Config files in `config/` are symlinked with `mkOutOfStoreSymlink`, so edits take effect immediately without rebuilding.

## Usage

```bash
# Rebuild and switch
sudo nixos-rebuild switch --flake .#karpalo
# or
make switch

# Build without switching
sudo nixos-rebuild build --flake .#karpalo

# Test (switch but don't set as boot default)
sudo nixos-rebuild test --flake .#karpalo

# Update flake inputs
nix flake update

# Garbage collection
sudo nix-collect-garbage -d
```
