local map = vim.keymap.set

-- Clipboard: copy to system clipboard
map("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- Clipboard: paste from system clipboard
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Toggle hlsearch
map("n", "<leader><space>", "<cmd>set hlsearch!<cr>", { desc = "Toggle hlsearch" })

-- Config reload
map("n", "<leader>xx", "<cmd>source $MYVIMRC<cr>", { desc = "Reload init.lua" })
map("n", "<leader>x", "<cmd>source %<cr>", { desc = "Source current file" })
