local spec = {
  -- common plugin dependencies
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",

  -- misc
  {
    "glacambre/firenvim",
    lazy = false,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    cond = function()
      return vim.g.started_by_firenvim
    end,
    settings = "firenvim",
  },
}

return require("axie.lazy").transform_spec(spec, "misc")
