-- https://github.com/kabouzeid/nvim-lspinstall --

return function()
	-- Manual overrides for language server settings
	local language_server_overrides = {
		lua = {
			settings = {
				Lua = {
					diagnostics = {
						-- get language server to recognise `vim` global for nvim config
						globals = { "vim" }
					},
				}
			}
		},
	}

	local function setup_servers()
		require'lspinstall'.setup()
		local servers = require'lspinstall'.installed_servers()
		for _, server in pairs(servers) do
			local override = language_server_overrides[server]
			if override ~= nil then
				require'lspconfig'[server].setup(override)
			else
				require'lspconfig'[server].setup{}
			end
		end
	end

	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	require'lspinstall'.post_install_hook = function()
		setup_servers() -- reload installed servers
		vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
	end
end
