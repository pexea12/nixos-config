{ config, pkgs, ... }:

let
  configDir = "${config.home.homeDirectory}/nixos-config/config";
in
{
  # Make configDir available to all imported modules
  _module.args = { inherit configDir; };

  imports = [
    ./user_modules/fonts.nix
    ./user_modules/shell.nix
    ./user_modules/tmux.nix
    ./user_modules/neovim.nix

    # Apps
    ./user_modules/browsers.nix
    ./user_modules/polybar.nix
    ./user_modules/i3.nix
    ./user_modules/display.nix
    ./user_modules/audio.nix
    ./user_modules/pcmanfm.nix
    ./user_modules/zed.nix
    ./user_modules/claude-code.nix
  ];

  home.username = "pexea12";
  home.homeDirectory = "/home/pexea12";
  home.stateVersion = "25.05";

  # ibus environment variables for input method support
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    QT_IM_MODULE = "ibus";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "dzungnguyenvn@outlook.com";
        name = "Dzung Nguyen";
      };
      core.editor = "nvim";
    };
  };

  programs.bash.enable = true;

  # TODO: Disable VSCode
  programs.vscode.enable = true;

  home.packages = with pkgs; [
    bat
    ripgrep
    gnumake
    jq

    # Productivity
    logseq
    anki
    signal-desktop
    devbox
    copier
    gh

    # Utils
    brightnessctl
    imagemagick
    unzip
    ffmpeg
    feh
    playerctl
    sox
    tree
    psmisc
    vlc
  ];


  # TODO: Add vscode config
  # TODO: Use variable for pexea12
  # TODO: Configure power profile for battery (power saving) and also configure waybar
}
