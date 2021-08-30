-- https://github.com/kabouzeid/nvim-lspinstall --

return function()
	local lsp_install = require("lspinstall")
	local lsp_config = require("lspconfig")
	local lsp_utils = require("lspconfig.util")

	-- Manual overrides for language server settings
	local language_server_overrides = {
		lua = {
			settings = {
				Lua = {
					diagnostics = {
						-- get language server to recognise `vim` global for nvim config
						globals = { "vim" },
					},
				},
			},
		},
		-- haskell = {
		-- Modified from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/hls.lua
		-- root_dir = lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'),
		-- root_dir = function(fname)
		-- 	return lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml')(fname)
		-- 	or vim.fn.getcwd()
		-- end,
		-- }
	}

	local function setup_servers()
		lsp_install.setup()
		local servers = lsp_install.installed_servers()
		for _, server in pairs(servers) do
			local override = language_server_overrides[server]
			if override ~= nil then
				lsp_config[server].setup(override)
			else
				lsp_config[server].setup({
					-- root_dir = vim.loop.cwd, -- NOTE: may override default root_dir
				})
			end
		end
	end

	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	lsp_install.post_install_hook = function()
		setup_servers() -- reload installed servers
		vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
	end
end
