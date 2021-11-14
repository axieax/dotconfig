-- https://github.com/kabouzeid/nvim-lspinstall --
-- NOTE: auto open install window: use nvim_open_win config option noautocmd

return function()
  -- lsp setup
  require("lsp").pre_install()

  local lsp_install = require("lspinstall")
  local lsp_config = require("lspconfig")
  -- local lsp_utils = require("lspconfig.util")
  local language_server_overrides = require("lsp.utils").language_server_overrides

  -- default config
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  local default_config = {
    capabilities = capabilities,
  }

  local function setup_servers()
    lsp_install.setup()
    local servers = lsp_install.installed_servers()
    for _, server in pairs(servers) do
      local override = language_server_overrides[server] or default_config
      -- lsp_config[server].setup(override)
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

  local function setup_emmet()
    -- https://github.com/aca/emmet-ls --
    -- https://github.com/kozer/emmet-language-server --
    local configs = require("lspconfig/configs")
    local util = require("lspconfig/util")

    if not lsp_config.emmet_language_server then
      configs.emmet_language_server = {
        default_config = {
          cmd = { "emmet-language-server", "--stdio" },
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "javascript",
            "typescript",
            "javascript.jsx",
            "typescript.tsx",
            "css",
          },
          root_dir = util.root_pattern("package.json", ".git"),
          settings = {},
        },
      }
    end
    lsp_config.emmet_language_server.setup({ capabilities = capabilities })
  end

  setup_servers()
  -- setup_emmet()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  lsp_install.post_install_hook = function()
    setup_servers() -- reload installed servers
    -- setup_emmet()
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
end
