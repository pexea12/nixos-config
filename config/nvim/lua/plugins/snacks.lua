vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  bigfile = { enabled = true },
  indent = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  git = { enabled = true },
  gitbrowse = { enabled = true },
})

vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Snacks: Git browse" })
vim.keymap.set({ "n", "v" }, "<leader>sH", function() Snacks.notifier.show_history() end, { desc = "Snacks: Show notifier history" })
