{ config, pkgs, lib, configDir, ... }:

{
  programs.waybar.enable = true;

  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/waybar";
  };
}
