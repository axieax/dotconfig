local spec = {
  -- ALT: https://github.com/zbirenbaum/copilot.lua with https://github.com/zbirenbaum/copilot-cmp
  { "github/copilot.vim", event = "InsertEnter", settings = "copilot" },
  { "folke/todo-comments.nvim", event = "VeryLazy", settings = "todo" },

  {
    -- TODO: automatically install parsers for new file types (don't download all)
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    settings = "treesitter",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
  {
    "nvim-treesitter/playground",
    build = ":TSUpdate query",
    cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor", "TSCaptureUnderCursor", "TSHighlightCapturesUnderCursor" },
  },
  -- TODO: use fork https://github.com/mrjones2014/nvim-ts-rainbow instead?
  { "p00f/nvim-ts-rainbow", event = "BufReadPost" },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost", settings = "indentline" },
  { "code-biscuits/nvim-biscuits", event = "BufReadPost", settings = "biscuits" },
  {
    -- Argument highlights
    "m-demare/hlargs.nvim",
    event = "BufReadPost",
    opts = {
      -- Catppuccin Flamingo
      color = "#F2CDCD",
      -- NOTE: needs to be lower than Twilight.nvim's priority of 10000
      hl_priority = 9999,
    },
  },
  { "narutoxy/dim.lua", event = "VeryLazy", config = true },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<Space>/", "<Cmd>Neogen<CR>", desc = "Generate docstring" } },
    opts = { snippet_engine = "luasnip" },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
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
  { "mfussenegger/nvim-dap", settings = "plugins.editor.debug.dap" },
  { "nvim-telescope/telescope-dap.nvim", settings = "plugins.editor.debug.dap_telescope" },
  -- dapui, dap virtaul text (config = true)

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
    ft = { "markdown", "text", "tex", "plaintex" },
    event = "InsertEnter *md",
    dependencies = "hrsh7th/nvim-cmp",
    settings = "autolist",
  },
}

return require("axie.lazy").transform_spec(spec, "editor")
