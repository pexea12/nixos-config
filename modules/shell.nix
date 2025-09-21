{ configDir }:
{ config, pkgs, lib, ... }:

# zsh and tmux config
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      saveNoDups = true;
      ignorePatterns = [
        "rm *"
        "cd *"
        "pkill *"
      ];
    };

    historySubstringSearch.enable = true;

    prezto = {
      enable = true;
      prompt.theme = "steeef";
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "completion"
        "git"
        "prompt"
        "history-substring-search"
      ];
    };
  };

  programs.tmux.enable = true;

  xdg.configFile."tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux";
  };
}
