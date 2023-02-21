local M = {}

local utils = require("axie.utils")

--- Returns the custom options for a given language server
---@param name string @The name of the language server
---@return table @The custom options for the language server
function M.get(name)
  return vim.tbl_extend("keep", M[name](), M.default())
end

--- Default function which is invoked when a language server is attached
---@param client table @The language server client
---@param bufnr number @Attached buffer number
function M.default_on_attach(client, bufnr)
  -- document formatting
  if client.supports_method("textDocument/formatting") then
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local null_can_format = require("axie.plugins.lsp.null").use_null_formatting(filetype)
    client.server_capabilities.documentFormattingProvider = not (null_can_format and client.name ~= "null-ls")

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "LSP Formatting",
      group = vim.api.nvim_create_augroup(string.format("LSP Formatting (buf: %s)", bufnr), {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end

  -- Code lens
  require("lsp-inlayhints").on_attach(client, bufnr)
  require("axie.plugins.lsp.signature").on_attach(bufnr)

  -- LSP keymaps
  local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  map("n", "\\<Space>", function()
    require("lsp-inlayhints").toggle()
  end, { desc = "Toggle inlay hints" })

  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "gK", function()
    -- TODO: use `customise_handler` from axie.lsp.config
    local _, winnr = vim.diagnostic.open_float({ border = "rounded" })
    if winnr then
      vim.api.nvim_win_set_option(winnr, "winblend", 20)
    end
  end, { desc = "Show line diagnostics" })
  map("n", "[d", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
  end, { desc = "Previous diagnostic" })
  map("n", "]d", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
  end, { desc = "Next diagnostic" })

  map("n", "gr", function()
    require("telescope.builtin").lsp_references()
  end, { desc = "References" })
  map("n", "gi", function()
    require("telescope.builtin").lsp_implementations()
  end, { desc = "Implementations" })
  map("n", "gt", vim.lsp.buf.type_definition, { desc = "Type definition" })
  map("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
  end, { desc = "Definition" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })

  map("n", "<Space>rn", function()
    require("axie.plugins.lsp.rename").rename_empty()
  end, { desc = "Rename" })
  map("n", "<Space>rN", vim.lsp.buf.rename, { desc = "Rename (with placeholder)" })
  map("n", "<Space>rl", vim.lsp.codelens.run, { desc = "Run code lens" })
  map({ "n", "v" }, "<Space>ra", function()
    require("axie.plugins.lsp.code_actions").native(true)
  end, { desc = "Code actions (ignore null-ls)" })
  map({ "n", "v" }, "<Space>rA", function()
    require("axie.plugins.lsp.code_actions").native(false)
  end, { desc = "Code actions (all)" })

  map("n", "<Space>ll", vim.diagnostic.setloclist, { desc = "Document diagnostics" })
  map("n", "<Space>lL", vim.diagnostic.setqflist, { desc = "Project diagnostics" })
  map("n", "<Space>l;", utils.toggle_diagnostics, { desc = "Toggle diagnostics" })
  map("n", "<Space>ls", function()
    require("telescope.builtin").lsp_document_symbols()
  end, { desc = "Document symbols" })
  map("n", "<Space>lS", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, { desc = "Dynamic workspace symbols" })
end

function M.default()
  return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = M.default_on_attach,
    handlers = {
      -- TODO: move other handlers here
      ["textDocument/rename"] = require("axie.plugins.lsp.rename").rename_handler,
    },
  }
end

------------------------------------
-- Custom Language Server Options --
------------------------------------

function M.clangd()
  return {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
    capabilities = { offsetEncoding = { "utf-16" } },
  }
end

function M.emmet_ls()
  return {
    filetypes = {
      "html",
      "javascriptreact",
      "typescriptreact",
      "css",
      "sass",
      "scss",
      "less",
      -- "ruby",
      -- "typescript",
      -- "javascript",
      -- "svelte",
      -- "vue",
    },
  }
end

function M.eslint()
  -- local eslint_config = require("lspconfig.server_configurations.eslint")
  return {
    -- uncomment for yarn 2/pnp project support
    -- https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/eslint
    -- cmd = { "yarn", "exec", unpack(eslint_config.default_config.cmd) },
  }
end

function M.grammarly()
  return {
    autostart = false,
    settings = { grammarly = { dialect = "australian" } },
  }
end

function M.hls()
  local root_pattern = require("lspconfig.util").root_pattern
  return {
    -- Modified from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/hls.lua
    -- root_dir = root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git"),
    -- root_dir = function(fname)
    --   return root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")(fname)
    --     or vim.fn.getcwd()
    -- end,
  }
end

function M.jdtls()
  local operating_system = utils.get_os()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local java_bundles =
    vim.fn.globpath(mason_path, "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 0, 1)

  vim.list_extend(java_bundles, vim.fn.globpath(mason_path, "java-test/extension/server/*.jar", 0, 1))
  -- TEMP: Failed to get bundleInfo for bundle from com.microsoft.java.test.runner-jar-with-dependencies.jar
  java_bundles = vim.tbl_filter(function(bundle)
    return not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
  end, java_bundles)

  local jdtls_path = mason_path .. "/jdtls"
  local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local jdtls_workspaces = vim.fn.stdpath("cache") .. "/jdtls_workspaces/"
  vim.fn.mkdir(jdtls_workspaces, "p")

  local java_runtimes = {}
  if operating_system == "linux" then
    local runtime_base_path = "/usr/lib/jvm/"
    local runtime_paths = vim.fn.globpath(runtime_base_path, "java-*", 0, 1)
    for _, rtp in ipairs(runtime_paths) do
      table.insert(java_runtimes, {
        name = rtp:match(runtime_base_path .. "(.*)"),
        path = rtp,
      })
    end
  elseif operating_system == "mac" then
    local runtime_base_path = "/Library/Java/JavaVirtualMachines/"
    local jdks = vim.fn.globpath(runtime_base_path, "*", 0, 1)
    for _, jdk in ipairs(jdks) do
      table.insert(java_runtimes, {
        name = jdk:match(runtime_base_path .. "(.*)"),
        path = jdk .. "/Contents/Home/bin",
      })
    end
  end

  return {
    autostart = false,
    init_options = {
      bundles = java_bundles,
      -- https://github.com/j-hui/fidget.nvim/issues/57
      extendedClientCapabilities = { progressReportProvider = false },
    },
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      vim.fn.globpath(jdtls_path, "plugins/org.eclipse.equinox.launcher_*.jar"),
      "-configuration",
      jdtls_path .. "/config_" .. operating_system,
      "-data",
      jdtls_workspaces .. workspace_dir,
    },
    settings = {
      java = {
        configuration = {
          -- NOTE: for changing java runtime dynamically with :JdtSetRuntime
          runtimes = java_runtimes,
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
  }
end

function M.jsonls()
  return {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  }
end

function M.ltex()
  return {
    settings = {
      ltex = {
        language = "en-AU",
      },
    },
  }
end

function M.lua_ls()
  local settings = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- get language server to recognise `vim` global for nvim config
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  }

  local ok, neodev = pcall(require, "neodev")
  if ok then
    neodev.setup({
      library = {
        runtime = true,
        plugins = true,
      },
    })
  end
  return settings
end

function M.tsserver()
  return {
    init_options = {
      hostInfo = "neovim",
      preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  }
end

function M.rust_analyzer()
  return {
    autostart = false,
    tools = { inlay_hints = { auto = false } },
  }
end

function M.yamlls()
  return {
    settings = {
      yaml = {
        -- CloudFormation tags
        customTags = {
          "!Base64",
          "!Cidr",
          "!FindInMap sequence",
          "!GetAtt",
          "!GetAZs",
          "!ImportValue",
          "!Join sequence",
          "!Ref",
          "!Select sequence",
          "!Split sequence",
          "!Sub sequence",
          "!Sub",
          "!And sequence",
          "!Condition",
          "!Equals sequence",
          "!If sequence",
          "!Not sequence",
          "!Or sequence",
        },
      },
    },
  }
end

return setmetatable(M, {
  __index = function(_, _)
    return function()
      return {}
    end
  end,
})
