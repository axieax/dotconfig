local M = {}

function M.config()
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
  vim.api.nvim_cmd({
    cmd = "highlight",
    args = { "link", "GitSignsDeleteLn", "ErrorMsg" },
  }, {})
end

return M
