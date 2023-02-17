local M = {}

-- TODO: up down bindings
M.keys = {
  {
    "<Space>d.",
    function()
      require("dap").run_last()
    end,
    desc = "Run last",
  },
  {
    "<Space>db",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Toggle breakpoint",
  },
  {
    "<Space>dB",
    function()
      local condition = vim.fn.input("Breakpoint condition: ")
      require("dap").set_breakpoint(condition)
    end,
    desc = "Set conditional breakpoint",
  },
  {
    "<Space>dj",
    function()
      require("dap").step_out()
    end,
    desc = "Step out",
  },
  {
    "<Space>dk",
    function()
      require("dap").step_into()
    end,
    desc = "Step into",
  },
  {
    "<Space>dl",
    function()
      require("dap").step_over()
    end,
    desc = "Step over",
  },
  {
    "<Space>dq",
    function()
      require("dap").close()
    end,
    desc = "Close",
  },
  {
    "<Space>dK",
    function()
      require("dap.ui.widgets").hover()
    end,
    desc = "Hover",
  },
}

function M.config()
  local sign = function(name, opts)
    opts = vim.tbl_extend("keep", opts, {
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define(name, opts)
  end

  sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
  sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition" })
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
end

return M
