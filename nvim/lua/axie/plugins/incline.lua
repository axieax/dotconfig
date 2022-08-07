-- https://github.com/b0o/incline.nvim --

return function()
  local maroon = "#EBA0AC"
  local mauve = "#CBA6F7"
  require("incline").setup({
    highlight = {
      groups = {
        InclineNormal = {
          guifg = maroon,
        },
        InclineNormalNC = {
          guifg = mauve,
        },
      },
    },
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      local icon, color = require("nvim-web-devicons").get_icon_color(filename)
      return {
        { icon, guifg = color },
        { " " },
        { filename },
      }
    end,
  })
end
