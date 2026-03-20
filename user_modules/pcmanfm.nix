{ config, pkgs, lib, configDir, ... }:

{
  home.packages = [ pkgs.pcmanfm ];

  xdg.configFile."pcmanfm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/pcmanfm";
  };
}
