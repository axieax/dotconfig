local M = {}

M.keys = {
  {
    "<Space>dc",
    function()
      require("telescope").extensions.dap.configurations()
    end,
    desc = "Configurations",
  },
  {
    "<Space>d?",
    function()
      require("telescope").extensions.dap.commands()
    end,
    desc = "Commands",
  },
  {
    "<Space>df",
    function()
      require("telescope").extensions.dap.frames()
    end,
    desc = "Frames",
  },
  {
    "<Space>dv",
    function()
      require("telescope").extensions.dap.variables()
    end,
    desc = "Variables",
  },
  {
    "<Space>d/",
    function()
      require("telescope").extensions.dap.list_breakpoints()
    end,
    desc = "Breakpoints",
  },
}

return M
