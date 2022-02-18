-- https://github.com/kosayoda/nvim-lightbulb --

local M = {}

function M.setup()
  vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'axie.plugins.lightbulb'.update()]])
end

function M.update()
  -- update status text
  require("nvim-lightbulb").update_lightbulb({
    ignore = { "null-ls" },
    sign = {
      enabled = false,
    },
    status_text = {
      enabled = true,
      text = " Code Action Available",
      -- text = " Code Action Available",
    },
  })

  -- display status
  local status = require("nvim-lightbulb").get_status_text()
  vim.api.nvim_echo({ { status, "WarningMsg" } }, false, {})
end

return M
