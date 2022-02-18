-- https://github.com/lewis6991/gitsigns.nvim --
return function()
  require("gitsigns").setup({
    keymaps = {
      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
      -- Text objects
      ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
      ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    },
    -- Alternative mode (highlight numbers instead of column)
    numhl = true,
    signcolumn = false,
    -- current_line_blame = true,
  })
  -- Toggle Git blame
  -- TODO: customise virtual text colour. angry prefix
  vim.cmd("highlight link GitSignsDeleteLn ErrorMsg")
end
