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
  -- NOTE: can be wrapped with https://github.com/TimUntersberger/neogit
  { "sindrets/diffview.nvim", settings = "diffview" },
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
}

return require("axie.lazy").transform_spec(spec, "project")
