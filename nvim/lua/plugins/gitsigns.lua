-- https://github.com/lewis6991/gitsigns.nvim --
return function()
  local map = require("utils").map
  require("gitsigns").setup({
    keymaps = {
      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
      -- Text objects
      -- ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
      -- ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    },
    -- Alternative mode (highlight numbers instead of column)
    numhl = true,
    signcolumn = false,
    -- current_line_blame = true,
  })
  -- Toggle Git blame
  -- TODO: customise virtual text colour. angry prefix
  map({ "n", "<space>g;", "<cmd>lua require'gitsigns'.toggle_current_line_blame()<CR>" })
  map({ "n", "<space>gh", "<cmd>lua require'gitsigns'.stage_hunk()<CR>" })
  map({ "v", "<space>gh", "<cmd>lua require'gitsigns'.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>" })
  map({ "n", "<space>gu", "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>" })
  map({ "n", "<space>gr", "<cmd>lua require'gitsigns'.reset_hunk()<CR>" })
  map({ "v", "<space>gr", "<cmd>lua require'gitsigns'.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>" })
  map({ "n", "<space>gR", "<cmd>lua require'gitsigns'.reset_buffer()<CR>" })
  map({ "n", "<space>gd", "<cmd>lua require'gitsigns'.preview_hunk()<CR>" })
  -- TODO: Git browse <space>gw
end
