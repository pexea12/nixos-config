vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- Install additional parsers beyond the bundled ones (lua, python, markdown, bash, vim, c)
local parsers = { "go", "yaml", "toml", "kotlin", "clojure", "rust", "nix", "python", "make" }
for _, parser in ipairs(parsers) do
  require("nvim-treesitter").install(parser)
end

-- Enable treesitter highlighting and indentation for all filetypes with a parser
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
