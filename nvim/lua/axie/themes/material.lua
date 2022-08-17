local M = {}

function M.config()
  vim.g.material_style = "palenight"
  require("material").setup({
    borders = true,
    disable = {
      background = true,
    },
    custom_highlights = {
      IndentBlanklineContextChar = { fg = "#C678DD" },
      TelescopeNormal = { bg = "NONE" },
      -- WhichKeyFloat = { bg = "#2632384D" },
      -- TODO: cmp item kind highlights
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
      -- HLGROUP = { link = "OTHER_GROUP" },
    },
  })
end

return M
