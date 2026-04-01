vim.pack.add({ "https://github.com/Shatur/neovim-ayu" })

require("ayu").setup({ mirage = false })
vim.cmd.colorscheme("ayu-dark")
