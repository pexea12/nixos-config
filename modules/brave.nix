{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.brave ];

  # Due to this issue https://github.com/hyprwm/Hyprland/discussions/11961
  # We have to create a new desktop entry file for brave to --disable-features=WaylandWpColorManagerV1
  # Revisit in 1 year. Last update: 2025.10.31
  # Probably do the same for all Chromium-based browsers

  home.file.".local/bin/brave-wayland" = {
    source = ../config/brave/brave-wayland.sh;
    executable = true;
  };

  home.file.".local/share/applications/brave-wayland.desktop" = {
    source = ../config/brave/brave-wayland.desktop;
  };
}
