{ config, pkgs, ... }:

let
  configDir = "${config.home.homeDirectory}/nixos-config/config";
in
{
  home.username = "pexea12";
  home.homeDirectory = "/home/pexea12";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userEmail = "dzungnguyenvn@outlook.com";
    userName = "Dzung Nguyen";
  };

  programs.bash.enable = true;

  programs.kitty.enable = true;

  # TODO: Disable VSCode
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    bat

    # Browsers
    chromium
    brave

    # Productivity
    logseq
    wofi

    # Utils
    brightnessctl

    # Fonts
    # TODO: Reconfigure fonts, split to a different modules
    # TODO: Set defaultFonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
  ];

  fonts.fontconfig.enable = true;

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
