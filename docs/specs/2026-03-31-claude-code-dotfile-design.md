# Claude Code Dotfile Configuration — Design Spec

## Goal

Track portable Claude Code settings (`settings.json`, custom commands, hooks, scripts) in the nixos-config repo so they can be symlinked to `~/.claude/` via GNU Stow on non-NixOS systems (macOS).

## Problem

Claude Code stores its configuration in `~/.claude/` which includes:
- `settings.json` — model preferences, plugins, effort level
- `commands/` — custom slash commands (`.md` files)
- `hooks/` — lifecycle hook scripts
- `scripts/` — utility scripts

These are not version-controlled, making them hard to reproduce across machines.

## Design

### Directory Structure

```
config/claude/
├── settings.json        # Portable settings (no machine-specific hooks)
├── commands/
│   ├── cost-history.md
│   └── create-github-pr.md
├── hooks/
│   └── .gitkeep
└── scripts/
    └── .gitkeep
```

### Portable vs Machine-Specific

The `settings.json` in this repo contains only portable settings:
- `model` — preferred model
- `effortLevel` — reasoning effort
- `enabledPlugins` — plugin toggles

Machine-specific settings (hooks, statusLine commands referencing local paths) are excluded and managed per-machine in `~/.claude/settings.json` directly.

### Stow Integration

Uses the existing `make link`/`make unlink` targets with a `TARGET` override:

```bash
make link APP=claude TARGET=~/.claude
make unlink APP=claude TARGET=~/.claude
```

The `TARGET` parameter is needed because Claude Code uses `~/.claude/` instead of the default `~/.config/<app>/` pattern.

## Constraints

- GNU Stow symlinks individual files, so machine-specific files in `~/.claude/` (like `projects/`, `todos/`, session data) are unaffected.
- The `settings.json` in this repo will be overwritten by Claude Code if settings change via the UI. Re-export portable settings periodically.
