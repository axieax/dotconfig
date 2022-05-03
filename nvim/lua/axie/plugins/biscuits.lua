-- https://github.com/code-biscuits/nvim-biscuits --

return function()
  -- context indicator
  local biscuits = require("nvim-biscuits")
  biscuits.setup({
    on_events = { "CursorMoved", "CursorMovedI" },
    -- cursor_line_only = true,
    default_config = {
      max_length = 24,
      min_distance = 4,
      prefix_string = " ﬌ ",
    },
  })

  vim.keymap.set("n", "<Space><Space>", biscuits.toggle_biscuits, { desc = "Toggle Biscuits" })

  -- vim.cmd([[highlight BiscuitColor ctermfg=cyan]])
  -- vim.cmd([[au BufEnter * hi default BiscuitColor ctermfg=cyan guifg=cyan]])
  -- vim.api.nvim_set_hl(0, "BiscuitColor", { ctermfg = "cyan" })
end
