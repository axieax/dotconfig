-- https://github.com/mfussenegger/nvim-dap --
-- https://github.com/Pocco81/DAPInstall.nvim --
-- TODO: setup (can use Telescope integration)

return function()
	local dap = require("dap")
	local map = require("utils").map

	require("dapui").setup()

	-- Keymaps
	map({ "n", "<Space>dp", "<cmd>lua require'dap'.run_last()<CR>" })
	map({ "n", "<Space>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>" })
	map({ "n", "<Space>dc", "<cmd>lua require'dap'.continue()<CR>" })
	map({ "n", "<Space>dh", "<cmd>lua require'dap'.step_out()<CR>" })
	map({ "n", "<Space>dl", "<cmd>lua require'dap'.step_into()<CR>" })
	map({ "n", "<Space>dj", "<cmd>lua require'dap'.step_over()<CR>" })
	map({ "n", "<Space>dq", "<cmd>lua require'dap'.close()<CR>" })
	map({ "n", "<Space>dm", "<cmd>lua require'dapui'.toggle()<CR>" })
	map({ "n", "<Space>dt", "<cmd>lua require'lsp.debug.helpers'.debug_test()<CR>" })
	-- map({ "n", "<Space>dC", "<cmd>Telescope dap configurations<CR>" })
	map({ "n", "<Space>dH", "<cmd>Telescope dap commands<CR>" })
	map({ "n", "<Space>df", "<cmd>Telescope dap frames<CR>" })
	map({ "n", "<Space>dv", "<cmd>Telescope dap variables<CR>" })
	map({ "n", "<Space>dB", "<cmd>Telescope dap list_breakpoints<CR>" })
	-- TODO: up down bindings

	-- Python setup (SETUP: pip install debugpy)
	local dap_python = require("dap-python")
	dap_python.setup("/usr/bin/python")
	dap_python.test_runner = "pytest"

	-- Java setup
	-- https://github.com/microsoft/java-debug
	-- https://github.com/microsoft/vscode-java-test
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end
