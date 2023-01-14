local M = {}

M.opts = {
  plugins = {
    spelling = { enabled = true },
    -- presets = { operators = false }, -- for modes.nvim
  },
  window = { winblend = 20 },
  layout = { align = "center" },
}

M.config = function(_, opts)
  local wk = require("which-key")
  wk.setup(opts)
  wk.register({
    ["<Space>f"] = { name = "find" },
    ["<Space>g"] = { name = "git" },
    ["<Space>gd"] = { name = "git diff" },
    ["<Space>d"] = { name = "debug" },
    ["<Space>l"] = { name = "lsp" },
    ["<Space>t"] = { name = "test" },
    ["<Space>r"] = { name = "run actions" },
    ["["] = { name = "previous" },
    ["]"] = { name = "next" },
  })
end

return M
