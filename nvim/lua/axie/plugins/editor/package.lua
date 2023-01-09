local M = {}

M.keys = {
  {
    ",pp",
    function()
      require("package-info").toggle()
    end,
    desc = "Toggle package versions",
  },
  {
    ",pu",
    function()
      require("package-info").update()
    end,
    desc = "Update package",
  },
  {
    ",pd",
    function()
      require("package-info").delete()
    end,
    desc = "Delete package",
  },
  {
    ",pi",
    function()
      require("package-info").install()
    end,
    desc = "Install package",
  },
  {
    ",pv",
    function()
      require("package-info").change_version()
    end,
    desc = "Change version",
  },
}

M.config = true

return M
