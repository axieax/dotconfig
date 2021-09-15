local M = {}

local java_bundles = {
  vim.fn.glob("~/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
}
vim.list_extend(java_bundles, vim.split(vim.fn.glob("~/java/vscode-java-test/server/*.jar"), "\n"))

M.language_server_overrides = {
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
  java = {
    init_options = {
      bundles = java_bundles,
    },
    cmd = {
      -- jdtls start script
      vim.fn.expand("~/.local/share/nvim/lspinstall/java/jdtls.sh"),
      -- workspace data directory
      -- vim.fn.expand("~/java/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")),
      require("jdtls.setup").find_root({ ".git" }),
    },
    on_attach = function(client, bufnr)
      require("jdtls.setup").add_commands()
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
    end,
    root_dir = require("jdtls.setup").find_root({ "gradle.build", "pom.xml" }),
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

function M.jdtls_setup()
  print(vim.inspect(M.language_server_overrides.java))
  require("jdtls").start_or_attach(M.language_server_overrides.java)
end

return M
