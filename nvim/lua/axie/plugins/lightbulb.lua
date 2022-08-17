-- https://github.com/kosayoda/nvim-lightbulb --

local M = {}

function M.config()
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

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    desc = "Check for available code actions",
    callback = require("axie.plugins.lightbulb").update,
  })
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
