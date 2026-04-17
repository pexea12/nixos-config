vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
})

require("blink.cmp").setup({
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = {
      download = true,
      force_version = "v1.10.2",
    },
  },
  completion = {
    ghost_text = { enabled = true },
    documentation = { auto_show = true },
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
  signature = { enabled = true },
})
