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
