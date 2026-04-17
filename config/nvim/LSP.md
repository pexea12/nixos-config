# LSP Keymaps Cheatsheet

## Navigation

| Key | Action | Source |
|-----|--------|--------|
| `gd` | Go to definition | lsp.lua |
| `gD` | Go to declaration | lsp.lua |
| `gy` | Go to type definition | lsp.lua |
| `gri` | Go to implementation | nvim default |
| `grr` | Go to references | nvim default |
| `gO` | Document symbols (telescope) | telescope.lua |
| `grw` | Workspace symbols (telescope) | telescope.lua |

## Code Actions

| Key | Action | Source |
|-----|--------|--------|
| `K` | Hover documentation | nvim default |
| `grn` | Rename symbol | nvim default |
| `gra` | Code action | nvim default |
| `gf` | Format buffer | lsp.lua |

## Diagnostics

| Key | Action | Source |
|-----|--------|--------|
| `]d` | Next diagnostic | lsp.lua |
| `[d` | Previous diagnostic | lsp.lua |
| `,d` | Show diagnostic float | lsp.lua |
| `,dd` | Diagnostics loclist | lsp.lua |

## Completion

Built-in LSP completion with autotrigger. Use `<C-n>` / `<C-p>` to navigate the menu, `<C-y>` to confirm.
