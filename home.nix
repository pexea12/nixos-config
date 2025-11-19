{ config, pkgs, ... }:

let
  configDir = "${config.home.homeDirectory}/nixos-config/config";
in
{
  # Make configDir available to all imported modules
  _module.args = { inherit configDir; };

  imports = [
    ./modules/fonts.nix
    ./modules/shell.nix

    # Apps
    ./modules/brave.nix
    ./modules/polybar.nix
    ./modules/i3.nix
  ];

  home.username = "pexea12";
  home.homeDirectory = "/home/pexea12";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "dzungnguyenvn@outlook.com";
        name = "Dzung Nguyen";
      };
    };
  };

  programs.bash.enable = true;
  programs.firefox.enable = true;

  # TODO: Disable VSCode
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    bat

    # Browsers
    chromium

    # Productivity
    logseq
    anki
    claude-code

    # Utils
    brightnessctl
    pcmanfm
    imagemagick
    unzip
    ffmpeg
    feh
    playerctl
    tree
    psmisc
  ];


  # TODO: Add vscode config
  # TODO: Use variable for pexea12
  # TODO: Configure power profile for battery (power saving) and also configure waybar
}
