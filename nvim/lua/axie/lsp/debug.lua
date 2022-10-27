local M = {}

function M.dap_config()
  local dap = require("dap")

  local sign = vim.fn.sign_define
  sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

  -- TODO: up down bindings
  vim.keymap.set("n", "<Space>dp", dap.run_last, { desc = "Run last" })
  vim.keymap.set("n", "<Space>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<Space>dB", function()
    local condition = vim.fn.input("Breakpoint condition: ")
    dap.set_breakpoint(condition)
  end, { desc = "Breakpoint set conditional" })
  vim.keymap.set("n", "<Space>dj", dap.step_out, { desc = "Step out" })
  vim.keymap.set("n", "<Space>dk", dap.step_into, { desc = "Step into" })
  vim.keymap.set("n", "<Space>dl", dap.step_over, { desc = "Step over" })
  vim.keymap.set("n", "<Space>dq", dap.close, { desc = "Stop" })
end

function M.dap_telescope_config()
  local telescope = require("telescope")
  telescope.load_extension("dap")

  vim.keymap.set("n", "<Space>dc", telescope.extensions.dap.configurations, { desc = "configurations" })
  vim.keymap.set("n", "<Space>d?", telescope.extensions.dap.commands, { desc = "comands" })
  vim.keymap.set("n", "<Space>df", telescope.extensions.dap.frames, { desc = "frames" })
  vim.keymap.set("n", "<Space>dv", telescope.extensions.dap.variables, { desc = "variables" })
  vim.keymap.set("n", "<Space>d/", telescope.extensions.dap.list_breakpoints, { desc = "breakpoints" })
end

function M.dapui_config()
  local dap = require("dap")
  local dapui = require("dapui")
  dapui.setup()

  -- Open terminal to side
  local dapui_terminal = dap.defaults.fallback.terminal_win_cmd
  dap.defaults.fallback.terminal_win_cmd = function()
    local result = dapui_terminal()
    dapui.open(2) -- open dapui repl + console
    return result
  end

  vim.keymap.set("n", "<Space>d;", function()
    local windows = require("dapui.windows")
    -- just repl + console open
    if not windows.layouts[1]:is_open() and windows.layouts[2]:is_open() then
      dapui.close(2)
    end
    dapui.toggle()
  end, { desc = "Toggle UI" })
  vim.keymap.set("n", "<Space>dd", function()
    dap.toggle(2)
  end, { desc = "Toggle UI console" })
end

function M.dap_virtual_text_config()
  require("nvim-dap-virtual-text").setup()
end

function M.dap_python_config()
  -- SETUP: pip install debugpy
  local dap_python = require("dap-python")
  dap_python.setup()
  dap_python.test_runner = "pytest"
end

return M
