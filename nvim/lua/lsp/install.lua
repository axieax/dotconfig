-- https://github.com/williamboman/nvim-lsp-installer --
-- TODO: update all language servers

local M = {}

function M.default_on_attach(client, bufnr)
  -- documentSymbol
  if client.resolved_capabilities.documentSymbol then
    require("aerial").on_attach(client, bufnr)
  end

  -- documentFormatting
  local name = client.name
  local is_null = name == "null-ls"
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local ls_can_format = client.resolved_capabilities.document_formatting
  local null_can_format = require("lsp.null").use_null_formatting(filetype)

  -- print(name)
  -- print("ls_can_format", ls_can_format)
  -- print("null_can_format", null_can_format)

  -- prefer null-ls for formatting if available
  if (not is_null and null_can_format) or (is_null and not null_can_format) then
    -- disable formatting
    -- print("formatting disabled")
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  else
    -- use client for formatting
    -- print("formatting enabled")
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

  if client.resolved_capabilities.code_lens then
    print(name, "supports code lens")
    -- NOTE: language server loading delay
    vim.cmd("au BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()")
  end
end

function M.ls_overrides()
  -- sumnneko_lua setup
  local lua_rtps = vim.split(package.path, ";")
  vim.list_extend(lua_rtps, { "lua/?.lua", "lua/?/init.lua" })

  -- jdtls setup
  local java_bundles = {
    vim.fn.glob("~/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
  }
  vim.list_extend(java_bundles, vim.split(vim.fn.glob("~/java/vscode-java-test/server/*.jar"), "\n"))

  local jdtls_path = vim.fn.expand("~/.local/share/nvim/lsp_servers/jdtls")
  local os = require("utils").get_os()
  local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  -- local runtime_base_path = "/usr/lib/jvm/"
  -- local java_runtimes = {}
  -- local runtime_paths = vim.split(vim.fn.glob(runtime_base_path .. "java-*"), "\n")
  -- for _, rtp in ipairs(runtime_paths) do
  --   -- carve everything after java-*
  --   table.insert(java_runtimes, {
  --     name = rtp:match(runtime_base_path .. "(.*)"),
  --     path = rtp,
  --   })
  -- end

  return {
    -- LUA: sumneko_lua
    sumneko_lua = {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            -- path = { "?.lua", "?/init.lua" }, -- default
            -- path = lua_rtps,
          },
          diagnostics = {
            -- get language server to recognise `vim` global for nvim config
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            -- NOTE: LSP support for runtime files (e.g. plugins require definition), but slow
            -- library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },

    -- JAVA: jdtls
    jdtls = {
      init_options = { bundles = java_bundles },
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
      settings = {
        java = {
          configuration = {
            -- NOTE: for changing java runtime dynamically with :JdtSetRuntime
            -- runtimes = java_runtimes,
          },
        },
      },
      on_attach = function(client, bufnr)
        M.default_on_attach(client, bufnr)

        -- Java extensions setup
        -- https://github.com/microsoft/java-debug
        -- https://github.com/microsoft/vscode-java-test
        require("jdtls").setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
        require("jdtls.setup").add_commands()

        -- Telescope for UI picker (Neovim < 0.6)
        -- require("jdtls.ui").pick_one_async = require("plugins.telescope").jdtls_ui_picker
      end,
    },

    -- JS/TS: tsserver
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
        M.default_on_attach(client, bufnr)

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
        -- TODO: extract to utils
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

    -- HASKELL: hls
    -- haskell = {
    --   -- Modified from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/hls.lua
    --   root_dir = lsp_utils.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git"),
    --   root_dir = function(fname)
    --     return lsp_utils.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")(fname)
    --       or vim.fn.getcwd()
    --   end,
    -- },

    -- HTML: Emmet
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

    -- JSON: jsonls
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      },
    },

    -- DEFAULT: default configuration
    default = {
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      on_attach = M.default_on_attach,
      handlers = {
        ["textDocument/rename"] = require("lsp.rename").rename_handler,
      },
    },
  }
end

-- Auto install required language servers defined in utils.config
-- TODO: update as well?
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
    local name = server.name
    local ls_overrides = require("lsp.install").ls_overrides()
    local opts = ls_overrides[name] or ls_overrides.default
    opts = vim.tbl_extend("keep", opts, ls_overrides.default)

    -- Extra options
    -- NOTE: this is for yarn 2 / pnp support
    --[[ if name == "eslint" then
      local eslint_config = require("lspconfig.server_configurations.eslint")
      opts.cmd = vim.list_extend({ "yarn", "node" }, eslint_config.default_config.cmd)
    end ]]

    -- Register setup
    if name == "rust_analyzer" then
      -- Initialize the LSP via rust-tools instead
      require("rust-tools").setup({
        -- The "server" property provided in rust-tools setup function are the
        -- settings rust-tools will provide to lspconfig during init.            --
        -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
        -- with the user's own settings (opts).
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
      })
      server:attach_buffers()
    elseif name ~= "jdtls" then
      server:on_ready(function()
        server:setup(opts)
      end)
    end
  end
end

-- Setup jdtls language server for java files
function M.setup_jdtls()
  local ls_overrides = M.ls_overrides()
  local opts = vim.tbl_extend("keep", ls_overrides.jdtls, ls_overrides.default)
  require("jdtls").start_or_attach(opts)
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
