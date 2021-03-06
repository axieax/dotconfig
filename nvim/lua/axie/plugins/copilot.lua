-- https://github.com/github/copilot.vim --

return function()
  local copilot_enabled = require("axie.utils.config").copilot_enabled
  vim.g.copilot_filetypes = { ["*"] = copilot_enabled }

  local opts = { script = true, expr = true, silent = true }
  vim.keymap.set("i", "<c-a>", "copilot#Accept()", opts)
  vim.keymap.set("i", "<c-x>", "copilot#Dismiss()", opts)
  vim.keymap.set("i", "<c-,>", "copilot#Previous()", opts)
  vim.keymap.set("i", "<c-.>", "copilot#Next()", opts)
  -- vim.keymap.set("i", "<a-[>", "copilot#Previous()", opts)
  -- vim.keymap.set("i", "<a-]>", "copilot#Next()", opts)
  vim.g.copilot_no_tab_map = true
end
