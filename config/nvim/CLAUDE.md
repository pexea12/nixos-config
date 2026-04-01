# Neovim Config

Created: 2026-03-31
Requires: Neovim 0.12+

## File Structure

```
config/nvim/
├── CLAUDE.md           # This file
├── init.lua            # Entry point (loads modules in order)
└── lua/
    ├── options.lua     # Editor options (indentation, line numbers, leader key, editorconfig)
    ├── keymaps.lua     # Key mappings (clipboard, hlsearch toggle, config reload)
    ├── autocmds.lua    # Autocommands (yank highlight)
    └── plugins/
        ├── init.lua        # Auto-imports all plugin files in this directory
        ├── theme.lua       # neovim-ayu colorscheme setup
        └── treesitter.lua  # nvim-treesitter config + additional parsers
```

## Plugin Management: vim.pack

This config uses neovim 0.12's built-in `vim.pack` instead of lazy.nvim. There is no lazy loading — plugins are loaded at startup.

Each plugin gets its own self-contained file in `lua/plugins/`. Files are auto-imported by `lua/plugins/init.lua` — no manual registration needed (like lazy.nvim).

### Adding a new plugin

Just create a new file `lua/plugins/<name>.lua`. It will be auto-imported. Each file should call `vim.pack.add()` for its plugin and then configure it:

```lua
-- lua/plugins/new-plugin.lua
vim.pack.add({ "https://github.com/author/new-plugin" })

require("new-plugin").setup({
  -- config here
})
```

`vim.pack.add()` always takes a list (table). For plugins with dependencies, include all URLs in one call:

```lua
vim.pack.add({
  "https://github.com/dependency/one",
  "https://github.com/author/main-plugin",
})
```

### Current plugins

- **Shatur/neovim-ayu** (`theme.lua`) — ayu-dark colorscheme
- **nvim-treesitter/nvim-treesitter** (`treesitter.lua`) — syntax highlighting + indent for additional languages (go, yaml, toml, kotlin, clojure, rust). Neovim 0.12 bundles parsers for lua, python, markdown, bash, vim, c.
- **nvim-neo-tree/neo-tree.nvim** (`neo-tree.lua`) — file tree (`<leader>e` toggle, `<leader>o` focus)

## Deployment

On non-NixOS systems (e.g. macOS), use GNU Stow:

```bash
make link APP=nvim    # symlinks config/nvim/ → ~/.config/nvim/
make unlink APP=nvim  # removes the symlinks
```

On first launch, `vim.pack` will automatically clone and install plugins.

## Editorconfig

Enabled via `vim.g.editorconfig = true` in `options.lua`. Uses the repo root `/.editorconfig` — no separate editorconfig file needed in this directory.

## Future additions (not yet implemented)

- LSP configuration (vim.lsp.enable)
- Telescope (fuzzy finder)
- Completion (blink.cmp)
- Statusline (lualine)
