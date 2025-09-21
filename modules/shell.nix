{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestions = {
      enable = true;
      highlight = true;
      strategy = "history";
    };
    syntaxHighlighting.enable = true;
    history = {
      saveNoDups = true;
    };

    prezto = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
  };
}
