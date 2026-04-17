local servers = { "basedpyright", "ruff" }

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- ruff handles imports
      analysis = {
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false -- use basedpyright's hover
  end,
})

vim.lsp.enable(servers)

-- Format on save via ruff
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({
      filter = function(client) return client.name == "ruff" end,
      timeout_ms = 3000,
    })
  end,
})

return servers
