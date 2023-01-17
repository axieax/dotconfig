-----------------------------
-- Project / Git Utilities --
-----------------------------

-- TODO: nvim ide project settings plugin
-- gh.nvim, litee?

local spec = {
  -- Project stuff
  {
    -- Project scope
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    keys = { { "<Space>fP", "<Cmd>Telescope projects<CR>", desc = "Recent projects" } },
    config = function()
      require("project_nvim").setup()
    end,
  },
  -- Project settings
  { "tpope/vim-sleuth", event = "VeryLazy" },

  -- Git stuff
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", settings = "gitsigns" },
  { "ruifm/gitlinker.nvim", settings = "gitlinker" },
  -- {
  --   -- GitHub issues and pull requests
  --   "pwntester/octo.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("octo").setup()
  --   end,
  -- },

  -- Git diff and history view
  -- NOTE: can be wrapped with https://github.com/TimUntersberger/neogit
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
      "DiffviewLog",
    },
    keys = {
      { "<Space>gdf", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git diff (file)" },
      { "<Space>gdr", "<Cmd>DiffviewFileHistory<CR>", desc = "Git diff (repo)" },
      { "<Space>gdm", "<Cmd>DiffviewOpen main<CR>", desc = "Git diff (main)" },
      { "<Space>gdM", "<Cmd>DiffviewOpen master<CR>", desc = "Git diff (master)" },
      { "<Space>gdq", "<Cmd>DiffviewClose<CR>", desc = "Git diff close" },
    },
    opts = { view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    } },
  },
}

return require("axie.lazy").transform_spec(spec, "project")
