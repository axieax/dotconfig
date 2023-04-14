local spec = {
  -- Common plugin dependencies
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  -- Misc
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = { window = { open = "alternate" }, nest_if_no_args = true },
  },
  {
    "glacambre/firenvim",
    lazy = false,
    build = function()
      -- NOTE: need to reinstall on nvim version upgrade
      require("lazy").load({ plugins = "firenvim", wait = true })
      vim.fn["firenvim#install"](0)
    end,
    cond = not not vim.g.started_by_firenvim,
    settings = "firenvim",
  },
}

return require("axie.lazy").transform_spec(spec, "misc")
