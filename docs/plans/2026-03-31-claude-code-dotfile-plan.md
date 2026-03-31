# Claude Code Dotfile Configuration — Implementation Plan

## Steps

1. **Create `config/claude/` directory structure** with `settings.json`, `commands/`, `hooks/`, `scripts/`
2. **Create cleaned `settings.json`** with portable settings only (model, effortLevel, enabledPlugins)
3. **Copy existing commands** from `~/.claude/commands/` (`cost-history.md`, `create-github-pr.md`)
4. **Create placeholder directories** with `.gitkeep` for `hooks/` and `scripts/`
5. **Update Makefile** to support optional `TARGET` parameter for `link`/`unlink` targets
6. **Save docs** — design spec and this plan

## Verification

```bash
# Link claude config
make link APP=claude TARGET=~/.claude

# Verify symlinks exist
ls -la ~/.claude/settings.json
ls -la ~/.claude/commands/

# Unlink
make unlink APP=claude TARGET=~/.claude

# Verify existing behavior unchanged
make link APP=tmux
make unlink APP=tmux
```

## Status

- [x] Create directory structure
- [x] Create portable settings.json
- [x] Copy command files
- [x] Create placeholder directories
- [x] Update Makefile with TARGET parameter
- [x] Save design spec and plan docs
