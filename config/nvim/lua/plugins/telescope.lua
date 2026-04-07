-- fzf-native requires a build step; use PackChanged hook for install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim"
      and (ev.data.kind == "install" or ev.data.kind == "update") then
      local dir = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/opt/telescope-fzf-native.nvim")
      if dir == "" then
        dir = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/start/telescope-fzf-native.nvim")
      end
      if dir ~= "" then vim.fn.system({ "make", "-C", dir }) end
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
})
-- plenary.nvim and nvim-web-devicons already added by neo-tree

-- One-time startup build in case plugin is already installed but not yet built
local fzf_dir = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/opt/telescope-fzf-native.nvim")
if fzf_dir == "" then
  fzf_dir = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/start/telescope-fzf-native.nvim")
end
if fzf_dir ~= "" and not vim.uv.fs_stat(fzf_dir .. "/build/libfzf.so")
  and not vim.uv.fs_stat(fzf_dir .. "/build/libfzf.dylib") then
  vim.fn.system({ "make", "-C", fzf_dir })
end

require("telescope").setup({
  pickers = {
    find_files = {
      theme = "dropdown",
    },
  },
  extensions = {
    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find files" })
vim.keymap.set("n", "<leader>ev", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Telescope: Find config files" })
vim.keymap.set("n", "<leader>ed", function()
  builtin.find_files({ cwd = vim.fn.stdpath("data") })
end, { desc = "Telescope: Find data files" })
vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "Telescope: Help tags" })
vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Telescope: Live grep" })
vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { desc = "Telescope: LSP document symbols" })
vim.keymap.set("n", "grw", builtin.lsp_dynamic_workspace_symbols, { desc = "Telescope: LSP workspace symbols" })
