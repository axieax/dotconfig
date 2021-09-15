-- https://github.com/kabouzeid/nvim-lspinstall --

return function()
  local lsp_install = require("lspinstall")
  local lsp_config = require("lspconfig")
  -- local lsp_utils = require("lspconfig.util")
	local language_server_overrides = require('lsp.utils').language_server_overrides

  -- Manual overrides for language server settings
  -- https://github.com/microsoft/java-debug
  -- https://github.com/microsoft/vscode-java-test

  local function setup_servers()
    lsp_install.setup()
    local servers = lsp_install.installed_servers()
    for _, server in pairs(servers) do
      local override = language_server_overrides[server] or {}
      if server ~= "java" then
        lsp_config[server].setup(override)
      end
    end

    vim.cmd([[
		augroup lspjava
			au!
			au FileType java lua require'lsp.utils'.jdtls_setup()
		augroup end
		]])
  end

  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  lsp_install.post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
end
