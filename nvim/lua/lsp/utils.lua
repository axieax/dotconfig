-- TODO: Java code actions from https://github.com/mfussenegger/nvim-jdtls#usage
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
      vim.fn.expand("~/java/workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")),
      -- vim.fn.expand("~/java/workspaces/" .. require("jdtls.setup").find_root({ ".git" })),
      -- require("jdtls.setup").find_root({ ".git" }),
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
              local selection = actions.get_selected_entry(prompt_bufnr)
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
  -- }
}

function M.jdtls_setup()
  require("jdtls").start_or_attach(M.language_server_overrides.java)
end

return M
