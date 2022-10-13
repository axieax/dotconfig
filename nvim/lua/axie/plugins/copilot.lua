local M = {}

function M.setup()
  local opts = { script = true, expr = true, silent = true }
  vim.keymap.set("i", "<C-a>", "copilot#Accept()", opts)
  vim.keymap.set("i", "<C-x>", "copilot#Dismiss()", opts)
  vim.keymap.set("i", "<A-[>", "copilot#Previous()", opts)
  vim.keymap.set("i", "<A-]>", "copilot#Next()", opts)
  -- vim.keymap.set("i", "<A-\\>", "<Cmd>Copilot panel<CR>")

  vim.g.copilot_no_tab_map = true
end

function M.config()
  local copilot_enabled = require("axie.utils.config").copilot_enabled
  vim.g.copilot_enabled = copilot_enabled
end

return M
