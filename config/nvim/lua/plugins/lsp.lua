vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
})

require("mason").setup()

-- Language-specific LSP configs are in lua/plugins/lang/
-- Each module returns its list of servers for mason to install
local ensure_installed = {}
vim.list_extend(ensure_installed, require("plugins.lang.python"))
vim.list_extend(ensure_installed, require("plugins.lang.lua"))

require("mason-lspconfig").setup({
  ensure_installed = ensure_installed,
})

-- Keymaps and completion on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    -- Navigation (grn, gra, grr, gri, gO, K are Neovim 0.12 defaults)
    map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
    map("n", "gy", vim.lsp.buf.type_definition, "LSP: Go to type definition")

    -- Formatting
    map("n", "gf", function() vim.lsp.buf.format({ async = true }) end, "LSP: Format buffer")

    -- Diagnostics
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
    map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic float")
    map("n", "<leader>dd", vim.diagnostic.setloclist, "Diagnostics loclist")

  end,
})

