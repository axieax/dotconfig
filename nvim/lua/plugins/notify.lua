-- https://github.com/rcarriga/nvim-notify --

return function()
  require("notify").setup({
    background_colour = "#000000",
    render = "minimal",
    on_open = function(win)
      -- transparent background
      vim.api.nvim_win_set_option(win, "winblend", 30)
      -- vim.api.nvim_win_set_option(win, "winhighlight", "Normal:TelescopeNormal,NormalNC:TelescopeNormal")
      -- TRY: https://github.com/folke/zen-mode.nvim/blob/main/lua/zen-mode/view.lua#L198-L210
    end,
  })
end
