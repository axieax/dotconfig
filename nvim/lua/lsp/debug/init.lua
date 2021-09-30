-- https://github.com/mfussenegger/nvim-dap --
-- https://github.com/Pocco81/DAPInstall.nvim --
-- TODO: setup (can use Telescope integration)

return function()
  local map = require("utils").map
  require("dapui").setup()

  -- Keymaps
  map({ "n", "<Space>dp", "<cmd>lua require'dap'.run_last()<CR>" })
  map({ "n", "<Space>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>" })
  map({ "n", "<Space>dB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" }) -- NOTE: not toggle
  map({ "n", "<Space>dj", "<cmd>lua require'dap'.step_out()<CR>" })
  map({ "n", "<Space>dk", "<cmd>lua require'dap'.step_into()<CR>" })
  map({ "n", "<Space>dl", "<cmd>lua require'dap'.step_over()<CR>" })
  map({ "n", "<Space>dq", "<cmd>lua require'dap'.close()<CR>" })

  map({ "n", "<Space>dc", "<cmd>Telescope dap configurations<CR>" })
  map({ "n", "<Space>dh", "<cmd>Telescope dap commands<CR>" })
  map({ "n", "<Space>df", "<cmd>Telescope dap frames<CR>" })
  map({ "n", "<Space>dv", "<cmd>Telescope dap variables<CR>" })
  map({ "n", "<Space>d/", "<cmd>Telescope dap list_breakpoints<CR>" })

  map({ "n", "<Space>d;", "<cmd>lua require'dapui'.toggle()<CR>" })
  map({ "n", "<Space>dt", "<cmd>lua require'lsp.debug.helpers'.debug_test()<CR>" })
  -- TODO: up down bindings

  -- Python setup (SETUP: pip install debugpy)
  local dap_python = require("dap-python")
  dap_python.setup("/usr/bin/python")
  dap_python.test_runner = "pytest"

  -- Virtual text
  vim.g.dap_virtual_text = true
end
