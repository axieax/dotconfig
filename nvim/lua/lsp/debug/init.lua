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
	map({ "n", "<Space>dC", "<cmd>Telescope dap configurations<CR>" })
	map({ "n", "<Space>dH", "<cmd>Telescope dap commands<CR>" })
	map({ "n", "<Space>df", "<cmd>Telescope dap frames<CR>" })
	map({ "n", "<Space>dv", "<cmd>Telescope dap variables<CR>" })
	map({ "n", "<Space>dB", "<cmd>Telescope dap list_breakpoints<CR>" })
	-- TODO: up down bindings

	-- Python setup (SETUP: pip install debugpy)
	-- local dap_python = require("dap-python")
	-- dap_python.setup("/usr/bin/python")
	-- dap_python.test_runner = "pytest"

	-- Overrides
	local debugger_overrides = {
		python_dbg = {
			adapters = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			},
			configurations = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				},
			},
		},
	}

	-- DAPInstall
	local dap_install = require("dap-install")
	local dbg_list = require("dap-install.debuggers_list").debuggers

	for debugger, _ in pairs(dbg_list) do
		local override = debugger_overrides[debugger] or {}
		dap_install.config(debugger, override)
	end
end
