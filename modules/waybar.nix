{ config, pkgs, lib, ... }:

{
  programs.waybar.enable = true;

  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink ../config/waybar;
  };
}
