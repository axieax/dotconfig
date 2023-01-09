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
      { "<Space>gd", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git diff (file)" },
      { "<Space>gD", "<Cmd>DiffviewFileHistory<CR>", desc = "Git diff (repo)" },
      { "<Space>gq", "<Cmd>DiffviewClose<CR>", desc = "Git diff close" },
    },
  },
}

return require("axie.lazy").transform_spec(spec, "project")
