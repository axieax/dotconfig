local M = {}

M.cmd = "Copilot"

M.keys = {
  -- https://github.com/community/community/discussions/29817#discussioncomment-4217615
  { "<C-a>", "copilot#Accept()", mode = "i", expr = true, silent = true, replace_keycodes = false },
  { "<C-x>", "copilot#Dismiss()", mode = "i", expr = true, silent = true },
  { "<A-[>", "copilot#Previous()", mode = "i", expr = true, silent = true },
  { "<A-]>", "copilot#Next()", mode = "i", expr = true, silent = true },
  { "<A-\\>", "<Cmd>Copilot panel<CR>", mode = "i" },
}

function M.init()
  vim.g.copilot_enabled = require("axie.utils.config").copilot_enabled
  vim.g.copilot_no_tab_map = true

  -- vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#6c7086" }) -- Catppuccin Overlay0
end

return M
