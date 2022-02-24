-- https://github.com/kosayoda/nvim-lightbulb --

local M = {}

function M.setup()
  require("nvim-lightbulb").setup({
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

  vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'axie.plugins.lightbulb'.update()]])
end

function M.update()
  -- update status
  local lightbulb = require("nvim-lightbulb")
  lightbulb.update_lightbulb()

  -- display status
  local status = lightbulb.get_status_text()
  vim.api.nvim_echo({ { status, "WarningMsg" } }, false, {})
end

return M
