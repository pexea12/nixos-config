{ config, pkgs, configDir, ... }:

{
  home.packages = [
    pkgs.claude-code
    pkgs.pi-coding-agent
    (pkgs.writeShellScriptBin "ccusage" ''
      export PATH="${pkgs.nodejs}/bin:$PATH"
      npx --yes ccusage "$@"
    '')
  ];

  # Symlink settings.json (model, marketplaces, enabled plugins/skills, MCPs)
  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/claude/settings.json";
  };

  # Symlink custom slash commands (~/.claude/commands/)
  home.file.".claude/commands" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/claude/commands";
  };

  # Symlink scripts (~/.claude/scripts/)
  home.file.".claude/scripts" = {
    source = config.lib.file.mkOutOfStoreSymlink "${configDir}/claude/scripts";
  };
}
