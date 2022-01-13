-- https://github.com/kosayoda/nvim-lightbulb --

return function()
  -- update status text
  require("nvim-lightbulb").update_lightbulb({
    sign = {
      enabled = false,
    },
    status_text = {
      enabled = true,
      text = " Code Action Available",
      -- text = " Code Action Available",
    },
  })
  -- print status
  -- hl groups: https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
  -- NOTE: this currently does not disappear after a while :(
  local status = require("nvim-lightbulb").get_status_text()
  vim.api.nvim_echo({ { status, "WarningMsg" } }, false, {})
end
