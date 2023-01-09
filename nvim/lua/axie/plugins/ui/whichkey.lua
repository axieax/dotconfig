local M = {}

function M.config()
  local wk = require("which-key")
  wk.setup({
    layout = { align = "center" },
    window = { winblend = 20 },
    -- For modes.nvim
    -- plugins = {
    --   presets = {
    --     operators = false,
    --   },
    -- },
  })
end

return M
