vim.pack.add({
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  render_modes = { "n", "v", "i", "c" },
})
