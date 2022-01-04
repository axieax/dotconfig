-- https://github.com/marko-cerovac/material.nvim --

return function()
  vim.g.material_style = "palenight"
  require("material").setup({
    borders = true,
    disable = {
      background = true,
    },
    custom_highlights = {
      IndentBlanklineContextChar = { fg = "#C678DD" },
      StatusLine = { bg = "#00000000" },
      TelescopeNormal = { fg = require("utils").highlight_group_get("TelescopeNormal", "fg") }, -- remove BG
      -- WhichKeyFloat = { bg = "#2632384D" },
      -- TODO: cmp item kind highlights
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
      -- HLGROUP = { link = "OTHER_GROUP" },
    },
  })
  -- vim.cmd([[colorscheme material]])
end