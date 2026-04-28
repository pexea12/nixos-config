{ config, pkgs, configDir, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [ gnumake gcc tree-sitter ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nvim";
  };
}
