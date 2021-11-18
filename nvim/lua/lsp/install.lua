-- https://github.com/williamboman/nvim-lsp-installer --
-- TODO: vim.tbl_extend default config with on_attach function (esp for jdtls)

local notify = require("notify")

local M = {}

-- Default capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- jdtls capabilities
local java_bundles = {
  vim.fn.glob("~/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
}
vim.list_extend(java_bundles, vim.split(vim.fn.glob("~/java/vscode-java-test/server/*.jar"), "\n"))

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

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
        extendedClientCapabilities = extendedClientCapabilities,
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
        -- Java setup
        -- https://github.com/microsoft/java-debug
        -- https://github.com/microsoft/vscode-java-test

        -- require("lsp").on_attach(client, bufnr)
        require("jdtls.setup").add_commands()
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
        -- client.resolved_capabilities.document_formatting = false

        -- Telescope
        local finders = require("telescope.finders")
        local sorters = require("telescope.sorters")
        local actions = require("telescope.actions")
        local pickers = require("telescope.pickers")
        local action_state = require("telescope.actions.state")

        require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
          local opts = {}
          pickers.new(opts, {
            prompt_title = prompt,
            finder = finders.new_table({
              results = items,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = label_fn(entry),
                  ordinal = label_fn(entry),
                }
              end,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry(prompt_bufnr)

                actions.close(prompt_bufnr)

                cb(selection.value)
              end)

              return true
            end,
          }):find()
        end
      end,
      -- root_dir = require("jdtls.setup").find_root({ ".git", "gradle.build", "pom.xml", "gradlew" }),
    },
    -- haskell = {
    -- Modified from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/hls.lua
    -- root_dir = lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'),
    -- root_dir = function(fname)
    -- 	return lsp_utils.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml')(fname)
    -- 	or vim.fn.getcwd()
    -- end,
    -- },

    default = {
      capabilities = capabilities,
    },
  }
end

-- Auto install required language servers defined in utils.config
function M.prepare_language_servers()
  local get_server = require("nvim-lsp-installer.servers").get_server
  local required_servers = require("utils.config").prepared_language_servers()

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
    if server.name ~= "jdtls" then
      server:on_ready(function()
        local ls_overrides = require("lsp.install").ls_overrides()
        local opts = ls_overrides[server.name] or ls_overrides.default
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
