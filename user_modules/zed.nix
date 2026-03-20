{ config, pkgs, configDir, ... }:

{
  home.packages = [ pkgs.zed-editor ];
  xdg.configFile."zed" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/zed";
  };
}
