-- https://github.com/olimorris/onedarkpro.nvim --

return function()
  require("onedarkpro").setup({
    -- extra from https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/colors.lua
    colors = {
      bg_blue = "#73b8f1",
      dark_purple = "#8a3fa0",
    },
    hlgroups = {
      -- TSProperty = { fg = "${gray}" },
      -- TSVariable = { fg = "${fg}" },
    },
    styles = {
      -- functions = "bold,italic",
      -- variables = "italic",
    },
    options = {
      transparency = true,
    },
  })
  -- require("onedarkpro").load()
end
