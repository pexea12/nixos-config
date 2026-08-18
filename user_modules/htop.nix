{ config, pkgs, lib, configDir, ... }:

{
  xdg.configFile."htop/htoprc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/htop/htoprc";
  };
}
