------------------------------------------
------------- Utility Plugins ------------
-- Provides helper functions for Neovim --
------------------------------------------

local spec = {
  { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { mapping = { "jk", "kj" } } },
  {
    "axieax/typo.nvim",
    event = "BufWinEnter",
    dev = true,
    keys = {
      {
        "<Space>E",
        function()
          require("typo").check()
        end,
        desc = "Typo check",
      },
    },
    config = true,
  },
  { "karb94/neoscroll.nvim", settings = "neoscroll" },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "abecodes/tabout.nvim",
    keys = {
      { "<A-l>", "<Plug>(TaboutMulti)", mode = "i" },
      { "<A-h>", "<Plug>(TaboutBackMulti)", mode = "i" },
    },
    opts = { tabkey = "", backwards_tabkey = "", act_as_tab = false },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  { "romainl/vim-cool", event = "VeryLazy" },
  { "mg979/vim-visual-multi", event = "VeryLazy" }, -- NOTE: too difficult to lazy load
  { "kevinhwang91/nvim-hlslens", settings = "hlslens" },
  {
    -- Underline word under cursor
    -- ALT: augroup with vim.lsp.buf.document_highlight and vim.lsp.buf.clear_references
    -- NOTE: this uses words instead of symbols (which LSP uses)
    -- TODO: `init` instead?
    "osyo-manga/vim-brightest",
    event = "VeryLazy",
    config = function()
      -- Highlight group (e.g. BrighestUndercurl)
      vim.g["brightest#highlight"] = { group = "BrightestUnderline" }
    end,
  },
  {
    -- CSS colours
    -- FORK: https://github.com/norcalli/nvim-colorizer.lua
    -- ALT: https://github.com/RRethy/vim-hexokinase
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { filetypes = { "*", "!prompt", "!popup", "!TelescopePrompt", "!toggleterm" } },
  },
  -- ALT: https://github.com/rmagatti/auto-session with https://github.com/rmagatti/session-lens
  { "Shatur/neovim-session-manager", event = "VimLeavePre", settings = "sessions" },
  { "ethanholz/nvim-lastplace", event = "BufReadPre", config = true },
  -- Keep cursor on shift (`>` or `<`) and filter (`=`)
  {
    "gbprod/stay-in-place.nvim",
    keys = {
      { ">", mode = { "n", "x" } },
      { "<", mode = { "n", "x" } },
      { "=", mode = { "n", "x" } },
      { ">>", mode = { "n" } },
      { "<<", mode = { "n" } },
      { "==", mode = { "n" } },
    },
    config = true,
  },
  -- Incrementor / decrementor
  { "monaqa/dial.nvim", settings = "dial" },
  {
    -- Unit converter
    "simonefranza/nvim-conv",
    cmd = {
      "ConvBin",
      "ConvDec",
      "ConvHex",
      "ConvOct",
      "ConvFarenheit",
      "ConvCelsius",
      "ConvStr",
      "ConvBytes",
      "ConvMetricImperial",
      "ConvDataTransRate",
      "ConvColor",
      "ConvSetPrecision",
    },
  },
  -- Text abbreviation / substitution / coercion
  { "tpope/vim-abolish", event = "VeryLazy" },
  {
    -- Case conversion
    "arthurxavierx/vim-caser",
    keys = { { "cR", mode = { "n", "v" } } },
    init = function()
      -- Works with motions, text objects and visual mode as well
      vim.g.caser_prefix = "cR"
    end,
  },
  -- Extra mappings (with encoding/decoding as well)
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  -- "." repeat for some commands
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ziontee113/icon-picker.nvim", settings = "iconpicker" },
  {
    "booperlv/nvim-gomove",
    keys = {
      { "<A-h>", mode = { "n", "v" } },
      { "<A-j>", mode = { "n", "v" } },
      { "<A-k>", mode = { "n", "v" } },
      { "<A-l>", mode = { "n", "v" } },
    },
    opts = {
      -- whether to not to move past line when moving blocks horizontally, (true/false)
      move_past_end_col = false,
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<Space>mm",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon mark file",
      },
      {
        "<Space>mM",
        function()
          -- TODO: telescope instead?
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon list",
      },
      {
        "<Space>ma",
        function()
          require("harpoon.ui").nav_file(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<Space>ms",
        function()
          require("harpoon.ui").nav_file(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<Space>md",
        function()
          require("harpoon.ui").nav_file(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<Space>mf",
        function()
          require("harpoon.ui").nav_file(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<Space>mg",
        function()
          require("harpoon.ui").nav_file(5)
        end,
        desc = "Harpoon file 5",
      },
      {
        "<Space>mh",
        function()
          require("harpoon.ui").nav_file(6)
        end,
        desc = "Harpoon file 6",
      },
      {
        "<Space>mj",
        function()
          require("harpoon.ui").nav_file(7)
        end,
        desc = "Harpoon file 7",
      },
      {
        "<Space>mk",
        function()
          require("harpoon.ui").nav_file(8)
        end,
        desc = "Harpoon file 8",
      },
      {
        "<Space>ml",
        function()
          require("harpoon.ui").nav_file(9)
        end,
        desc = "Harpoon file 9",
      },
      {
        "<Space>m,",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Harpoon prev",
      },
      {
        "<Space>m.",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Harpoon next",
      },
    },
  },
}

return require("axie.lazy").transform_spec(spec, "utility")
