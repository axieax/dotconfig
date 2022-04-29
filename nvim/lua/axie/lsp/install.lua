-- https://github.com/williamboman/nvim-lsp-installer --
-- TODO: update all language servers binding
-- TODO: separate ls_overrides into separate files?

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
  local null_can_format = require("axie.lsp.null").use_null_formatting(filetype)

  -- print(name)
  -- print("ls_can_format", ls_can_format)
  -- print("null_can_format", null_can_format)

  -- prefer null-ls for formatting if available
  if (not is_null and null_can_format) or (is_null and not null_can_format) then
    -- disable formatting
    -- print("formatting disabled for " .. name)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  else
    -- use client for formatting
    -- print("formatting enabled for " .. name)
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
  -- local lua_rtps = vim.split(package.path, ";")
  -- vim.list_extend(lua_rtps, { "lua/?.lua", "lua/?/init.lua" })

  -- eslint setup
  -- local eslint_config = require("lspconfig.server_configurations.eslint")

  -- jdtls setup
  local glob_split = require("axie.utils").glob_split
  local java_bundles = {
    vim.fn.glob("~/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
  }
  vim.list_extend(java_bundles, glob_split("~/java/vscode-java-test/server/*.jar"))

  local jdtls_path = vim.fn.expand("~/.local/share/nvim/lsp_servers/jdtls")
  local os = require("axie.utils").get_os()
  local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  -- local runtime_base_path = "/usr/lib/jvm/"
  -- local java_runtimes = {}
  -- local runtime_paths = glob_split(runtime_base_path .. "java-*")
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
          -- completion = {
          --   callSnippet = "Replace",
          -- },
          diagnostics = {
            -- get language server to recognise `vim` global for nvim config
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            -- NOTE: LSP support for runtime files (e.g. plugins require definition), but slow
            -- library = vim.api.nvim_get_runtime_file("", true),
            -- maxPreload = 10000,
            -- preloadFileSize = 10000,
          },
        },
      },
    },

    -- JAVA: jdtls
    jdtls = {
      autostart = false,
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
      end,
      handlers = {
        -- TEMP: https://github.com/j-hui/fidget.nvim/issues/57
        ["language/progressReport"] = function(_, result, ctx)
          local info = { client_id = ctx.client_id }

          local kind = "report"
          if result.complete then
            kind = "end"
          elseif result.workDone == 0 then
            kind = "begin"
          end

          local percentage = 0
          if result.totalWork > 0 and result.workDone >= 0 then
            percentage = result.workDone / result.totalWork * 100
          end

          local msg = {
            token = result.id,
            value = {
              kind = kind,
              percentage = percentage,
              title = result.task,
              message = result.subTask,
            },
          }

          vim.lsp.handlers["$/progress"](nil, msg, info)
        end,
      },
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
        vim.keymap.set("n", "\\<space>", "<CMD>TSLspToggleInlayHints<CR>", { desc = "Toggle Inlay Hints" })
      end,
    },

    -- JS/TS: eslint
    eslint = {
      -- uncomment for yarn 2/pnp project support
      -- https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/eslint
      -- cmd = { "yarn", "exec", unpack(eslint_config.default_config.cmd) },
    },

    -- MARKDOWN: grammarly
    grammarly = {
      autostart = false,
      settings = { grammarly = { dialect = "australian" } },
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

    -- RUST: rust_analyzer
    rust_analyzer = {
      autostart = false,
    },

    -- C/C++: clangd
    clangd = {
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
      capabilities = { offsetEncoding = { "utf-16" } },
    },

    -- DEFAULT: default configuration
    default = {
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      on_attach = M.default_on_attach,
      handlers = {
        -- TODO: move other handlers here
        ["textDocument/rename"] = require("axie.lsp.rename").rename_handler,
      },
    },
  }
end

function M.get_language_server_opts(name)
  local ls_overrides = require("axie.lsp.install").ls_overrides()
  return vim.tbl_extend("keep", ls_overrides[name] or {}, ls_overrides.default)
end

function M.setup_language_server(name, opts)
  opts = opts or require("axie.lsp.install").get_language_server_opts(name)
  require("lspconfig")[name].setup(opts)
end

function M.defer_server_setup(name, ft, cb)
  local opts = require("axie.lsp.install").get_language_server_opts(name)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      opts.autostart = true
      cb(opts)
    end,
  })
end

function M.setup()
  -- Connect nvim-lsp-installer to lspconfig
  local lsp_installer = require("nvim-lsp-installer")
  local ensure_installed = require("axie.utils.config").prepared_language_servers()
  lsp_installer.setup({
    ensure_installed = ensure_installed,
    automatic_installation = true,
  })

  -- Setup language servers
  local this = require("axie.lsp.install")
  local installed_servers = lsp_installer.get_installed_servers()
  for _, server in ipairs(installed_servers) do
    this.setup_language_server(server.name)
  end

  -- Setup language servers via autocmd
  this.defer_server_setup("jdtls", "java", function(opts)
    require("jdtls").start_or_attach(opts)
  end)
  this.defer_server_setup("rust_analyzer", "rust", require("rust-tools").setup)
  this.defer_server_setup("grammarly", "markdown", function(opts)
    vim.keymap.set("n", "\\g", function()
      -- Stop Grammarly client if active
      local clients = vim.lsp.buf_get_clients()
      for _, client in pairs(clients) do
        if client.name == "grammarly" then
          vim.lsp.stop_client(client.id)
          return
        end
      end
      -- Start Grammarly client
      this.setup_language_server("grammarly", opts)
    end, { desc = "Toggle Grammarly", silent = true })
  end)
end

return M
