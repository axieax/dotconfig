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
    keys = { { "<Space>fp", "<Cmd>Telescope media_files<CR>", desc = "Media files" } },
  },
  {
    "LinArcX/telescope-env.nvim",
    keys = { { "<Space>fE", "<Cmd>Telescope env env<CR>", desc = "Environment variables" } },
  },
  {
    "nvim-telescope/telescope-node-modules.nvim",
    keys = { { "<Space>fN", "<Cmd>Telescope node_modules list<CR>", desc = "Node modules" } },
  },
  {
    "jvgrootveld/telescope-zoxide",
    keys = { { "<Space>fz", "<Cmd>Telescope zoxide list<CR>", desc = "Zoxide" } },
  },
  {
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
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = "tami5/sqlite.lua",
    event = "VeryLazy",
    keys = {
      { "<Space>fy", "<Cmd>Telescope neoclip<CR>", desc = "Yank history" },
      { "<Space>fM", "<Cmd>Telescope macroscope<CR>", desc = "Macro history" },
    },
    opts = { enable_persistent_history = true, enable_macro_history = true },
  },
  { "axieax/urlview.nvim", dev = dev_mode, settings = "urlview" },
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
  -- m[ and m] to navigate marks as well
  { "chentoast/marks.nvim", event = "VeryLazy", config = true },
  {
    "simnalamburt/vim-mundo",
    keys = { { "<Space>fu", "<Cmd>MundoToggle<CR>", desc = "Undo tree" } },
    config = function()
      vim.g.mundo_auto_preview_delay = 0
      vim.g.mundo_playback_delay = 100
    end,
  },
}

return require("axie.lazy").transform_spec(spec, "ui")
