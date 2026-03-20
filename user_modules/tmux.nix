{ config, lib, configDir, ... }:

{
  programs.tmux.enable = true;

  xdg.configFile."tmux/tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux/tmux.conf";
  };
}
