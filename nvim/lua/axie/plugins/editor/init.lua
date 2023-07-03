local spec = {
  -- ALT: https://github.com/zbirenbaum/copilot.lua with https://github.com/zbirenbaum/copilot-cmp
  { "github/copilot.vim", event = "InsertEnter", settings = "copilot" },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    keys = {
      { "<Space>rc", "<Cmd>ChatGPT<CR>", desc = "ChatGPT" },
      {
        "<Space>rC",
        "<Cmd>ChatGPTEditWithInstructions<CR>",
        desc = "ChatGPTEditWithInstructions",
        mode = { "n", "v" },
      },
      { "<Space>rk", "<Cmd>ChatGPTActAs<CR>", desc = "ChatGPTActAs" },
    },
    opts = { popup_input = { submit = "<C-s>" } },
  },
  { "folke/todo-comments.nvim", event = "VeryLazy", settings = "todo" },

  {
    -- TODO: automatically install parsers for new file types (don't download all)
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    settings = "treesitter",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
  -- TODO: use fork https://github.com/HiPhish/nvim-ts-rainbow2 instead?
  { "p00f/nvim-ts-rainbow", event = "BufReadPost" },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost", settings = "indentline" },
  { "code-biscuits/nvim-biscuits", event = "BufReadPost", settings = "biscuits" },
  { "zbirenbaum/neodim", branch = "v2", event = "LspAttach", config = true },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<Space>/", "<Cmd>Neogen<CR>", desc = "Generate docstring" } },
    opts = { snippet_engine = "luasnip" },
  },
  {
    "numToStr/Comment.nvim",
    -- language-aware commentstring
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    settings = "comment",
  },
  { "tpope/vim-surround", event = "VeryLazy" },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      vim.cmd.highlight("MatchParen", "guibg=NONE")
    end,
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", settings = "autopairs" },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    config = true,
  },
  -- NOTE: requires treesitter regex
  { "bennypowers/nvim-regexplainer", build = ":TSUpdate regex", settings = "regexplainer" },
  { "nacro90/numb.nvim", event = "CmdlineEnter", opts = { number_only = true } },

  -- IDE tools
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", settings = "plugins.editor.debug.dapui" },
      { "theHamsta/nvim-dap-virtual-text", config = true },
    },
    settings = "plugins.editor.debug.dap",
  },
  { "nvim-telescope/telescope-dap.nvim", settings = "plugins.editor.debug.dap_telescope" },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      -- SETUP: pip install debugpy
      local dap_python = require("dap-python")
      dap_python.setup()
      dap_python.test_runner = "pytest"
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    ft = "lua",
    config = function()
      local dap = require("dap")
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      -- "mrcjkb/neotest-haskell",
      { "nvim-neotest/neotest-vim-test", dependencies = "vim-test/vim-test" },
    },
    settings = "test",
  },

  -- Python indenting issues
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
  { "Vimjas/vim-python-pep8-indent", ft = "python" },
  { "vuki656/package-info.nvim", ft = "json", settings = "package" },
  {
    -- NOTE: requires xclip (X11), wl-clipboard (Wayland) or pngpaste (MacOS)
    "ekickx/clipboard-image.nvim",
    ft = { "markdown", "latex", "plaintex", "tex", "org" },
    settings = "pasteimage",
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = { { ",O", "<Cmd>MarkdownPreview<CR>" } },
  },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    keys = { { ",o", "<Cmd>Glow<CR>" } },
    opts = {
      border = "rounded",
      pager = false,
    },
  },
  {
    -- NOTE: <C-t> (tab) to indent after auto continue, <C-d> (dedent) to unindent
    "gaoDean/autolist.nvim",
    ft = { "markdown", "txt", "tex", "plaintex" },
    dependencies = { "hrsh7th/nvim-cmp", "windwp/nvim-autopairs" },
    settings = "autolist",
  },
}

return require("axie.lazy").transform_spec(spec, "editor")
