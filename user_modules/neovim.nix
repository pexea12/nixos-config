{ config, pkgs, configDir, ... }:

{
  home.packages = with pkgs; [
    neovim
    gnumake
    gcc
    tree-sitter
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nvim";
  };
}
