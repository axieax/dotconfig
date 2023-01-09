-- OPTIONS:
--  - onedark
--  - dracula
--  - kanagawa

local M = {}

function M.config()
  require("themer").setup({
    transparent = true,
    dim_inactive = true,
    styles = {
      comment = { style = "italic" },
      ["function"] = { style = "italic" },
      functionbuiltin = { style = "italic" },
      variable = { style = "italic" },
      variableBuiltIn = { style = "italic" },
      parameter = { style = "italic" },
    },
    remaps = {
      palette = {},
      highlights = {
        kanagawa = {
          TSKeywordReturn = { fg = "#ff5d62" },
          VertSplit = { fg = "#16161D", bg = "NONE", gui = "NONE" },
        },
      },
    },
  })
end

return M
