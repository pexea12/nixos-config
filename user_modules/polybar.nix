{ config, pkgs, lib, configDir, ... }:

{
  home.packages = [
    (pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    })
  ];

  xdg.configFile."polybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/polybar";
  };
}
