-- https://github.com/williamboman/nvim-lsp-installer --
-- TODO: update all language servers

local M = {}

local default_on_attach = function(client, bufnr)
  -- NOTE: this additional check stops sumneko_lua from complaining during PackerCompile
  if client.resolved_capabilities.documentSymbol then
    require("aerial").on_attach(client, bufnr)
  end
end

-- jdtls setup
local java_bundles = {
  vim.fn.glob("~/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
}
vim.list_extend(java_bundles, vim.split(vim.fn.glob("~/java/vscode-java-test/server/*.jar"), "\n"))

local jdtls_path = vim.fn.expand("~/.local/share/nvim/lsp_servers/jdtls")
local os = vim.loop.os_uname().sysname:lower():gsub("darwin", "mac")
local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

function M.ls_overrides()
  return {
    -- lua: sumneko_lua
    sumneko_lua = {
      settings = {
        Lua = {
          diagnostics = {
            -- get language server to recognise `vim` global for nvim config
            globals = { "vim" },
          },
        },
      },
    },
    -- java: jdtls
    jdtls = {
      init_options = {
        bundles = java_bundles,
        -- extendedClientCapabilities = extendedClientCapabilities,
      },
      filetypes = { "java" },
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-noverify",
        "-Xmx1G",
        "-jar",
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_path .. "/config_" .. os,
        "-data",
        vim.fn.expand("~/java/workspaces/" .. workspace_dir),
        "--add-modules=ALL-SYSTEM",
        "--add-opens java.base/java.util=ALL-UNNAMED",
        "--add-opens java.base/java.lang=ALL-UNNAMED",
      },
      on_attach = function(client, bufnr)
        default_on_attach(client, bufnr)

        -- Java extensions setup
        -- https://github.com/microsoft/java-debug
        -- https://github.com/microsoft/vscode-java-test
        require("jdtls.setup").add_commands()
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()

        -- Telescope for UI picker (Neovim < 0.6)
        require("jdtls.ui").pick_one_async = require("plugins.telescope").jdtls_ui_picker
      end,
    },
    tsserver = {
      init_options = {
        hostInfo = "neovim",
        preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },

      on_attach = function(client, bufnr)
        default_on_attach(client, bufnr)

        -- disable formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
          -- inlay hints
          auto_inlay_hints = false,
          inlay_hints_highlight = "BiscuitColor",

          -- update imports on file move
          update_imports_on_move = true,
          require_confirmation_on_move = true,
          watch_dir = nil, -- fallback dir
        })

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- toggle inlay hints
        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.register({
            ["\\<space>"] = { "<CMD>TSLspToggleInlayHints<CR>", "Toggle Inlay Hints" },
          })
        else
          require("utils").map({ "n", "\\<space>", "<CMD>TSLspToggleInlayHints<CR>" })
        end
      end,
    },
    -- haskell = {
    -- Modified from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/hls.lua
    -- root_dir = lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'),
    -- root_dir = function(fname)
    -- 	return lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml')(fname)
    -- 	or vim.fn.getcwd()
    -- end,
    -- },
    -- Source: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/eslint
    -- eslint = {
    --   on_attach = function(client, bufnr)
    --     default_on_attach(client, bufnr)
    --     client.resolved_capabilities.document_formatting = true
    --   end,
    --   settings = {
    --     format = { enable = true },
    --   },
    -- },
    -- emmet_ls = {
    --   -- NOTE: doesn't work with jsx
    --   filetypes = {
    --     "html",
    --     "css",
    --     "javascript",
    --     "typescript",
    --     "eruby",
    --     "typescriptreact",
    --     "javascriptreact",
    --     "svelte",
    --     "vue",
    --   },
    -- },
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      },
    },
    default = {
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      on_attach = default_on_attach,
    },
  }
end

-- Auto install required language servers defined in utils.config
function M.prepare_language_servers()
  local required_servers = require("utils.config").prepared_language_servers()
  local get_server = require("nvim-lsp-installer.servers").get_server

  for _, server_name in ipairs(required_servers) do
    local available, server = get_server(server_name)
    if not available then
      require("utils").notify("Could not install language server " .. server_name, "error")
    elseif not server:is_installed() then
      server:install()
      require("utils").notify("Installed language server " .. server_name, "info")
    end
  end
end

-- Setup language servers for installed servers
function M.setup_language_servers()
  local installed_servers = require("nvim-lsp-installer.servers").get_installed_servers()

  for _, server in ipairs(installed_servers) do
    -- Get options for server
    local ls_overrides = require("lsp.install").ls_overrides()
    local opts = ls_overrides[server.name] or ls_overrides.default
    opts = vim.tbl_extend("keep", opts, ls_overrides.default)

    -- Extra options
    if server.name == "eslint" then
      opts.cmd = vim.list_extend({ "yarn", "node" }, server:get_default_options().cmd)
    end

    -- Register setup
    if server.name ~= "jdtls" then
      server:on_ready(function()
        server:setup(opts)
      end)
    end
  end
end

-- Setup jdtls language server for java files
function M.setup_jdtls()
  require("jdtls").start_or_attach(M.ls_overrides().jdtls)
end

function M.setup()
  require("lsp.install").prepare_language_servers()
  require("lsp.install").setup_language_servers()

  -- setup jdtls for java files
  vim.cmd([[
  augroup javalsp
    au!
    au FileType java lua require'lsp.install'.setup_jdtls()
  augroup end
  ]])
end

return M
