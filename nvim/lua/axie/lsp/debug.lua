-- https://github.com/mfussenegger/nvim-dap --
-- https://github.com/Pocco81/DAPInstall.nvim --
-- TODO: setup (can use Telescope integration)

return function()
  -- Open to side
  local dap = require("dap")
  dap.defaults.fallback.terminal_win_cmd = "10split new"

  require("dapui").setup()

  -- Python setup (SETUP: pip install debugpy)
  local dap_python = require("dap-python")
  dap_python.setup("/usr/bin/python")
  dap_python.test_runner = "pytest"

  -- Virtual text
  require("nvim-dap-virtual-text").setup()
end
