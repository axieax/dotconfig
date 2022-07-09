-- https://github.com/olimorris/onedarkpro.nvim --

return function()
  local onedarkpro = require("onedarkpro")
  local onedarkpro_utils = require("onedarkpro.utils")
  onedarkpro.setup({
    theme = "onedark_vivid",
    -- extra from https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/colors.lua
    colors = {
      -- NvChad Telescope theme (https://github.com/olimorris/onedarkpro.nvim/issues/31#issue-1160545258)
      onedark = {
        telescope_prompt = onedarkpro_utils.lighten(onedarkpro.get_colors("onedark").bg, 0.97),
        telescope_results = onedarkpro_utils.darken(onedarkpro.get_colors("onedark").bg, 0.85),
      },
      onelight = {
        telescope_prompt = onedarkpro_utils.darken(onedarkpro.get_colors("onelight").bg, 0.98),
        telescope_results = onedarkpro_utils.darken(onedarkpro.get_colors("onelight").bg, 0.95),
      },
    },
    hlgroups = {
      TSProperty = { fg = "${gray}" },
      TSVariable = { fg = "${fg}" },

      -- NvChad Telescope theme (https://github.com/olimorris/onedarkpro.nvim/issues/31#issue-1160545258)
      TelescopeBorder = {
        fg = "${telescope_results}",
        bg = "${telescope_results}",
      },
      TelescopePromptBorder = {
        fg = "${telescope_prompt}",
        bg = "${telescope_prompt}",
      },
      TelescopePromptCounter = { fg = "${fg}" },
      TelescopePromptNormal = { fg = "${fg}", bg = "${telescope_prompt}" },
      TelescopePromptPrefix = {
        fg = "${purple}",
        bg = "${telescope_prompt}",
      },
      TelescopePromptTitle = {
        fg = "${telescope_prompt}",
        bg = "${purple}",
      },

      TelescopePreviewTitle = {
        fg = "${telescope_results}",
        bg = "${green}",
      },
      TelescopeResultsTitle = {
        fg = "${telescope_results}",
        bg = "${telescope_results}",
      },

      TelescopeMatching = { fg = "${purple}" },
      TelescopeNormal = { bg = "${telescope_results}" },
      TelescopeSelection = { bg = "${telescope_prompt}" },
    },
    plugins = {
      polyglot = false,
    },
    styles = {
      -- functions = "bold,italic",
      -- variables = "italic",
    },
    options = {
      transparency = true,
    },
  })
end
