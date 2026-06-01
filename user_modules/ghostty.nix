{ config, configDir, ... }:

{
  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ghostty";
  };
}
