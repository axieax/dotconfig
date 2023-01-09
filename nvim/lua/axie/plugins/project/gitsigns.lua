local M = {}

M.keys = {
  {
    "<Space>gQ",
    function()
      require("gitsigns").toggle_numhl()
    end,
    desc = "Git gutter toggle",
  },
  {
    "<Space>g;",
    function()
      require("gitsigns").toggle_current_line_blame()
    end,
    desc = "Git blame toggle",
  },
  {
    "[g",
    function()
      require("gitsigns.actions").prev_hunk()
    end,
    desc = "Previous Git hunk",
  },
  {
    "]g",
    function()
      require("gitsigns.actions").next_hunk()
    end,
    desc = "Next Git hunk",
  },
  {
    "ih",
    function()
      require("gitsigns.actions").select_hunk()
    end,
    mode = { "o", "x" },
    desc = "Select Git hunk",
  },

  {
    "<Space>gR",
    function()
      require("gitsigns").reset_buffer()
    end,
    desc = "Git reset buffer",
  },
  {
    "<Space>gr",
    function()
      require("gitsigns").toggle_deleted()
    end,
    desc = "Git toggle deleted lines",
  },
}

M.config = {
  numhl = true,
  signcolumn = false,
  current_line_blame = false,
}

return M
