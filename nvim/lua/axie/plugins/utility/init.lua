------------------------------------------
------------- Utility Plugins ------------
-- Provides helper functions for Neovim --
------------------------------------------

local spec = {
  { "max397574/better-escape.nvim", event = "InsertCharPre", opts = { mapping = { "jk", "kj" } } },
  {
    -- Smooth scrolling
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup()
      require("neoscroll.config").set_mappings({
        -- https://github.com/karb94/neoscroll.nvim/issues/55
        -- ["{"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
        -- ["}"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
        -- ["<C-y>"] = { "scroll", { "-vim.wo.scroll", "false", "0" } },
        -- ["<C-e>"] = { "scroll", { "vim.wo.scroll", "false", "0" } },
        -- https://github.com/karb94/neoscroll.nvim/issues/50
        -- ["<ScrollWheelUp>"] = { "scroll", { "-0.10", "false", "50" } },
        -- ["<ScrollWheelDown>"] = { "scroll", { "0.10", "false", "50" } },
      })
      -- vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", "<C-y>")
      -- vim.keymap.set("i", "<ScrollWheelUp>", "<C-o><C-y>")
      -- vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", "<C-e>")
      -- vim.keymap.set("i", "<ScrollWheelDown>", "<C-o><C-e>")
    end,
  },
  -- Better quickfix list
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  -- Disable search highlights
  { "romainl/vim-cool", event = "VeryLazy" },
  -- Search virtual text
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
    config = true,
  },
  -- ALT: https://github.com/rmagatti/auto-session with https://github.com/rmagatti/session-lens
  { "Shatur/neovim-session-manager", event = "VimLeavePre", settings = "sessions" },
  {
    -- Remember last location
    -- ALT: https://github.com/farmergreg/vim-lastplace
    "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = true,
  },
  {
    -- Keep cursor on shift (`>` or `<`) and filter (`=`)
    "gbprod/stay-in-place.nvim",
    keys = { ">", "<", "=" },
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
    event = "VeryLazy",
    init = function()
      -- Works with motions, text objects and visual mode as well
      vim.g.caser_prefix = "cR"
    end,
  },
  { "ziontee113/icon-picker.nvim", settings = "iconpicker" },
}

return require("axie.lazy").transform_spec(spec, "utility")
