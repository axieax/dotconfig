-- https://github.com/rebelot/kanagawa.nvim --

return function()
  local default_colors = require("kanagawa.colors").setup()
  require("kanagawa").setup({
    transparent = true,
    overrides = {
      VertSplit = { fg = default_colors.bg_dark, bg = "NONE" },
      NormalFloat = { fg = default_colors.fg, bg = default_colors.sumiInk2 },
    },
  })

  -- vim.cmd("colorscheme kanagawa")
end
