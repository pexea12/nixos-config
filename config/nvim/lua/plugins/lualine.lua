vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
-- nvim-web-devicons already added by neo-tree

require("lualine").setup({
  options = {
    theme = "ayu_dark",
  },
})
