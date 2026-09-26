{ config, pkgs, lib, configDir, ... }:

{
  programs.tmux.enable = true;

  xdg.configFile."tmux/tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux/tmux.conf";
  };

  home.activation.installTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    fi
  '';

  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/herdr/config.toml";
  };
}
