{ config, pkgs, configDir, ... }:

{
  home.packages = [ pkgs.claude-code ];

  # Symlink settings.json (model, marketplaces, enabled plugins/skills, MCPs)
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/claude/settings.json";
  };

  # Symlink custom slash commands (~/.claude/commands/)
  home.file.".claude/commands" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/claude/commands";
  };
}
