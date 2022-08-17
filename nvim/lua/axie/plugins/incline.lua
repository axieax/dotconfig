local M = {}

function M.config()
  local colours = {
    maroon = "#EBA0AC",
    mauve = "#CBA6F7",
    yellow = "#F9E2AF",
  }

  require("incline").setup({
    highlight = {
      groups = {
        InclineNormal = {
          guifg = colours.maroon,
          gui = "bold",
        },
        InclineNormalNC = {
          guifg = colours.mauve,
        },
        InclineModified = {
          guifg = colours.yellow,
        },
      },
    },
    render = function(props)
      local bufname = vim.api.nvim_buf_get_name(props.buf)
      local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
      local icon, color = require("nvim-web-devicons").get_icon_color(filename)
      local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and " *" or " "

      return {
        { icon, guifg = color },
        { " " },
        { filename },
        { modified, group = "InclineModified" },
      }
    end,
  })
end

return M
