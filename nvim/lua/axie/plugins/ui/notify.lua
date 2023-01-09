local M = {}

M.keys = {
  { "<Space>fn", "<Cmd>Telescope notify<CR>", desc = "Search notifications" },
  {
    "<Space>Q",
    function()
      require("notify").dismiss()
    end,
    desc = "Dismiss notifications",
  },
}

function M.config()
  require("notify").setup({
    background_colour = "NormalFloat",
    render = "minimal",
    on_open = function(win)
      -- transparent background
      -- BUG: does not blend fully with transparent background
      -- TRY: https://github.com/folke/zen-mode.nvim/blob/main/lua/zen-mode/view.lua#L198-L210
      -- vim.api.nvim_win_set_option(win, "winblend", 40)
      -- vim.api.nvim_win_set_config(win, { zindex = 20000 })
      -- vim.api.nvim_win_set_option(win, "winhighlight", "Normal:NormalFloat")
    end,
  })

  -- vim.cmd([[
  --   highlight link NotifyERRORBody NormalFloat
  --   highlight link NotifyWARNBody NormalFloat
  --   highlight link NotifyINFOBody NormalFloat
  --   highlight link NotifyDEBUGBody NormalFloat
  --   highlight link NotifyTRACEBody NormalFloat
  -- ]])
end

return M
