-- https://github.com/williamboman/nvim-lsp-installer --
-- TODO: vim.tbl_extend default config with on_attach function (esp for jdtls)
-- TODO: common_on_attach

local notify = require("notify")

local M = {}

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
        -- Java extensions setup
        -- https://github.com/microsoft/java-debug
        -- https://github.com/microsoft/vscode-java-test
        require("jdtls.setup").add_commands()
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()

        -- Telescope for UI picker (Neovim < 0.6)
        require("jdtls.ui").pick_one_async = require("plugins.telescope").jdtls_ui_picker()
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
    eslint = {
      on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = true
      end,
      settings = {
        format = { enable = true },
      },
    },
    emmet_ls = {
      -- NOTE: doesn't work with jsx
      filetypes = {
        "html",
        "css",
        "javascript",
        "typescript",
        "eruby",
        "typescriptreact",
        "javascriptreact",
        "svelte",
        "vue",
      },
    },
    default = {
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
      notify("Could not install language server " .. server_name, "error")
    elseif not server:is_installed() then
      server:install()
      notify("Installed language server " .. server_name, "info")
    end
  end
end

-- Setup language servers for installed servers
function M.setup_language_servers()
  local installed_servers = require("nvim-lsp-installer.servers").get_installed_servers()

  for _, server in ipairs(installed_servers) do
    local ls_overrides = require("lsp.install").ls_overrides()
    local opts = ls_overrides[server.name] or ls_overrides.default
    if server.name == "eslint" then
      opts.cmd = vim.list_extend({ "yarn", "node" }, server:get_default_options().cmd)
    end
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
