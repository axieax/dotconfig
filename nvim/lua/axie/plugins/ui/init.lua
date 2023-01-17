local dev_mode = require("axie.utils.config").dev_mode

local spec = {
  { "folke/which-key.nvim", event = "VeryLazy", settings = "whichkey" },
  { "rebelot/heirline.nvim", event = "VeryLazy", settings = "statusline" },
  { "romgrk/barbar.nvim", event = "VeryLazy", settings = "barbar" },
  -- { "akinsho/bufferline.nvim", event = "VeryLazy", config = true },
  { "rcarriga/nvim-notify", settings = "notify" },
  {
    -- Tree explorer (filesystem, buffers, git_status)
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    event = "BufEnter", -- for netrw hijack
    settings = "neotree",
  },
  "mrbjarksen/neo-tree-diagnostics.nvim",
  { "nvim-telescope/telescope.nvim", settings = "telescope" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
      {
        "<Space>fe",
        function()
          require("telescope").extensions.file_browser.file_browser({ grouped = true })
        end,
        desc = "File explorer",
      },
    },
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    enabled = function()
      return require("axie.utils").get_os() == "linux"
    end,
    keys = {
      {
        "<Space>fp",
        function()
          require("telescope").extensions.media_files.media_files()
        end,
        desc = "Media files",
      },
    },
  },
  {
    "LinArcX/telescope-env.nvim",
    keys = {
      {
        "<Space>fE",
        function()
          require("telescope").extensions.env.env()
        end,
        desc = "Environment variables",
      },
    },
  },
  {
    "nvim-telescope/telescope-node-modules.nvim",
    keys = {
      {
        "<Space>fN",
        function()
          require("telescope").extensions.node_modules.list()
        end,
        desc = "Node modules",
      },
    },
  },
  {
    -- vim.ui overrides
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        get_config = function()
          local disabled_filetypes = { "neo-tree" }
          if vim.tbl_contains(disabled_filetypes, vim.bo.filetype) then
            return { enabled = false }
          end
        end,
      },
    },
  },
  { "axieax/urlview.nvim", dev = dev_mode, settings = "urlview" },
  -- cursor jump accent
  { "rainbowhxch/beacon.nvim", event = "VeryLazy" },
  { "petertriho/nvim-scrollbar", event = "VeryLazy", settings = "scrollbar" },
  { "anuvyklack/pretty-fold.nvim", event = "VeryLazy", config = true },
  {
    "anuvyklack/fold-preview.nvim",
    dependencies = "anuvyklack/nvim-keymap-amend",
    keys = { "zK" },
    config = function()
      local pretty_fold_preview = require("fold-preview")
      pretty_fold_preview.setup()

      local keymap_amend = require("keymap-amend")
      keymap_amend("n", "zK", pretty_fold_preview.mapping.show_close_preview_open_fold)
    end,
  },
  -- ALT: https://github.com/startup-nvim/startup.nvim
  { "goolord/alpha-nvim", event = "BufEnter", settings = "alpha" },
  { "akinsho/toggleterm.nvim", settings = "toggleterm" },
  "tknightz/telescope-termfinder.nvim",

  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    keys = { { "<Space>Z", "<Cmd>Twilight<CR>", desc = "Dim inactive text" } },
    config = true,
  },
  { "folke/zen-mode.nvim", settings = "zen" },
  { "chentoast/marks.nvim", event = "VeryLazy", config = true },
}

return require("axie.lazy").transform_spec(spec, "ui")
