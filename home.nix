{ config, pkgs, ... }:

{
  home.username = "pexea12";
  home.homeDirectory = "/home/pexea12";
  home.stateVersion = "25.05";

  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
 
  home.packages = with pkgs; [
    bat
    chromium
  ];

  # TODO: Use variable for pexea12
  # TODO: Try dunst, rofi
}
