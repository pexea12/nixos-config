{ config, pkgs, lib, configDir, ... }:

{
  xdg.configFile."pcmanfm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/pcmanfm";
  };
}
