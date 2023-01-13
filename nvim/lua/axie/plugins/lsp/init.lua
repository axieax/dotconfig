local spec = {
  -- LSP setup
  { "neovim/nvim-lspconfig", settings = "config" },
  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    settings = "install",
  },
  { "jose-elias-alvarez/null-ls.nvim", settings = "null" },
  "ThePrimeagen/refactoring.nvim",

  -- LSP server extensions
  -- "jose-elias-alvarez/typescript.nvim", -- for dynamic renames?
  "b0o/schemastore.nvim",
  "folke/neodev.nvim",
  {
    "mfussenegger/nvim-jdtls",
    init = function()
      local filetype_map = require("axie.utils").filetype_map
      filetype_map("java", "n", "<Space>tm", function()
        require("jdtls").test_nearest_method({
          after_test = require("axie.plugins.editor.test").test_summary,
        })
      end, { desc = "Test method" })
      filetype_map("java", "n", "<Space>tc", function()
        require("jdtls").test_class({
          after_test = require("axie.plugins.editor.test").test_summary,
        })
      end, { desc = "Test class" })
      filetype_map("java", "n", "<Space>t;", function()
        require("axie.plugins.editor.test").test_summary()
      end, { desc = "Test summary" })
    end,
  },
  "simrat39/rust-tools.nvim",

  -- LSP essentials
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      -- "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      "kdheepak/cmp-latex-symbols",
      { "David-Kunz/cmp-npm", config = true },
      { "petertriho/cmp-git", opts = { filetypes = { "*" } } },
      -- "quangnguyen30192/cmp-nvim-tags",
      -- "tpope/vim-dadbod",
      -- "kristijanhusak/vim-dadbod-ui",
      -- "kristijanhusak/vim-dadbod-completion",
      -- "tzachar/cmp-fzy-buffer",
      -- "tzachar/cmp-fuzzy-path",
    },
    settings = "completion",
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets", -- snippet collection
    settings = "snippets",
  },

  "ray-x/lsp_signature.nvim",
  {
    "lvimuser/lsp-inlayhints.nvim",
    opts = { inlay_hints = { highlight = "Comment" } },
  },

  -- LSP utils
  { "stevearc/aerial.nvim", settings = "aerial" },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        relative = "editor",
        blend = 0,
      },
    },
  },
}

return require("axie.lazy").transform_spec(spec, "lsp")
