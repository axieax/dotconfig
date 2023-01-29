local spec = {
  {
    -- TODO: replace all with themer.lua?
    "themercorp/themer.lua",
    enabled = false,
    settings = "themer",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    settings = "catppuccin",
  },
  {
    "marko-cerovac/material.nvim",
    settings = "material",
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    settings = "kanagawa",
  },
  {
    -- TODO: replace (too red)
    -- ALT: https://github.com/navarasu/onedark.nvim
    "olimorris/onedarkpro.nvim",
    settings = "onedark",
  },
  {
    "sam4llis/nvim-tundra",
    enabled = false,
    settings = "tundra",
  },
}

return require("axie.lazy").transform_spec(spec, "themes")
