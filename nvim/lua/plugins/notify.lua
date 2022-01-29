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
      -- https://github.com/ray-x/lsp_signature.nvim/blob/1178ad69ce5c2a0ca19f4a80a4048a9e4f748e5f/lua/lsp_signature/init.lua#L418-L420 works
    end,
  })
end
