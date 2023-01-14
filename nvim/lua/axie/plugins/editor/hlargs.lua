local M = {}

M.keys = {
  {
    "\\a",
    function()
      require("hlargs").toggle()
    end,
    desc = "Toggle argument highlights",
  },
}

M.opts = {
  -- Catppuccin Flamingo
  color = "#F2CDCD",
  -- NOTE: needs to be lower than Twilight.nvim's priority of 10000
  hl_priority = 9999,
}

return M
