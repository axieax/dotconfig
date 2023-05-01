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

  -- TODO: toggle stage hunk containing cursor with <Space>gh
  {
    "<Space>gh",
    function()
      require("gitsigns").stage_hunk()
    end,
    desc = "Git stage hunk",
  },
  {
    "<Space>gH",
    function()
      require("gitsigns").undo_stage_hunk()
    end,
    desc = "Git stage hunk (undo)",
  },
  {
    "<Space>gK",
    function()
      require("gitsigns").preview_hunk()
    end,
    desc = "Git preview hunk",
  },

  {
    "<Space>gD",
    function()
      require("gitsigns").preview_hunk_inline()
    end,
    desc = "Git toggle deleted lines",
  },
  {
    "<Space>gr",
    function()
      require("gitsigns").reset_hunk()
    end,
    desc = "Git reset hunk",
  },
  {
    "<Space>gR",
    function()
      require("gitsigns").reset_buffer()
    end,
    desc = "Git reset buffer",
  },
}

M.opts = {
  numhl = true,
  signcolumn = false,
  current_line_blame = false,
  -- TEMP: preview_hunk_inline with syntax highlighting
  _inline2 = true,
}

return M
