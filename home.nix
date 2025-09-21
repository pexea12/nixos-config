{ config, pkgs, ... }:

let
  configDir = "${config.home.homeDirectory}/nixos-config/config";
in
{
  imports = [
    ./modules/fonts.nix
    (import ./modules/shell.nix { inherit configDir; })
  ];

  home.username = "pexea12";
  home.homeDirectory = "/home/pexea12";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userEmail = "dzungnguyenvn@outlook.com";
    userName = "Dzung Nguyen";
  };

  programs.bash.enable = true;
  programs.firefox.enable = true;

  # TODO: Disable VSCode
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    bat

    # Browsers
    chromium
    brave

    # Productivity
    logseq

    # Utils
    brightnessctl
    pcmanfm

    ## Hyprland
    hyprlock
    hypridle
    rose-pine-hyprcursor

    ### Launcher
    wofi

    ## Screenshot
    grim
    slurp
    wl-clipboard
  ];

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/hypr";
  };

  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/waybar";
  };


  # TODO: Add vscode config
  # TODO: Use variable for pexea12
  # TODO: Try dunst
  # TODO: Modify waybar charging status for battery
  # TODO: Configure power profile for battery (power saving) and also configure waybar
}
