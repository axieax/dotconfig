local M = {}

function M.config()
  local default_colors = require("kanagawa.colors").setup()
  require("kanagawa").setup({
    transparent = true,
    overrides = {
      VertSplit = { fg = default_colors.bg_dark, bg = "NONE" },
      NormalFloat = { fg = default_colors.fg, bg = default_colors.sumiInk2 },
    },
  })
end

return M
