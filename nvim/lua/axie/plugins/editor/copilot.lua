local M = {}

M.keys = {
  -- script=true as well?
  { "<C-a>", "copilot#Accept()", mode = "i", expr = true, silent = true },
  { "<C-x>", "copilot#Dismiss()", mode = "i", expr = true, silent = true },
  { "<A-[>", "copilot#Previous()", mode = "i", expr = true, silent = true },
  { "<A-]>", "copilot#Next()", mode = "i", expr = true, silent = true },
  { "<A-\\>", "<Cmd>Copilot panel<CR>", mode = "i" },
}

function M.init()
  vim.g.copilot_enabled = require("axie.utils.config").copilot_enabled
  vim.g.copilot_no_tab_map = true
end

return M
