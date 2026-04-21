vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Gitsigns: " .. desc })
    end

    -- Navigation
    map("n", "]c", function() gs.nav_hunk("next") end, "Next hunk")
    map("n", "[c", function() gs.nav_hunk("prev") end, "Previous hunk")

    -- Actions
    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>gd", gs.diffthis, "Diff this")

    -- Visual mode stage/reset
    map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")

    -- Toggle inline blame
    map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle line blame")
  end,
})
