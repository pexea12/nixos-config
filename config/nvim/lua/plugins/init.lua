-- Auto-import all plugin files in this directory.
-- To add a new plugin, just create a new file in lua/plugins/.

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
  if file ~= "init.lua" and file:match("%.lua$") then
    require("plugins." .. file:gsub("%.lua$", ""))
  end
end

-- Convenience commands
vim.api.nvim_create_user_command("PackUpdate", function() vim.pack.update() end, { desc = "Update all plugins" })
vim.api.nvim_create_user_command("PackClean", function() vim.pack.clean() end, { desc = "Remove unused plugins" })
