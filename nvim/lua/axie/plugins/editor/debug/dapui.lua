local M = {}

function M.config()
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup({
    layouts = {
      {
        elements = {
          -- Elements can be strings or table with id and size keys.
          { id = "scopes", size = 0.25 },
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40, -- 40 columns
        position = "left",
      },
      {
        elements = {
          { id = "repl", size = 0.3 },
          { id = "console", size = 0.7 },
        },
        size = 0.25, -- 25% of total lines
        position = "bottom",
      },
    },
  })

  -- Open terminal to side
  local dapui_terminal = dap.defaults.fallback.terminal_win_cmd
  dap.defaults.fallback.terminal_win_cmd = function()
    local result = dapui_terminal()
    dapui.open(2) -- open dapui repl + console
    return result
  end

  local require_args = require("axie.utils").require_args
  vim.keymap.set("n", "<Space>d;", function()
    local windows = require("dapui.windows")
    -- just repl + console open
    if not windows.layouts[1]:is_open() and windows.layouts[2]:is_open() then
      dapui.close(2)
    end
    dapui.toggle()
  end, { desc = "Toggle UI" })
  vim.keymap.set("n", "<Space>dd", require_args(dapui.toggle, 2), { desc = "Toggle UI console" })
end
return M
