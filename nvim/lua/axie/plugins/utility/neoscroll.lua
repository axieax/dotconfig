local M = {}

M.keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb", "{", "}", "gg", "G" }

-- REF: https://github.com/roobert/neoscroll-motions.nvim
local function calculate_pattern_lines(pattern, backwards)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local direction = backwards and "b" or "n"
  local pattern_line = vim.api.nvim_call_function("search", { pattern, direction })
  local line_diff = pattern_line - current_line
  print(current_line, pattern_line, line_diff, direction)
  require("neoscroll").scroll(line_diff, true, 50)
end

M.config = function()
  require("neoscroll").setup()

  -- https://github.com/karb94/neoscroll.nvim/issues/55
  -- BUG: scrolls to the wrong line sometimes
  -- vim.keymap.set("n", "{", function()
  --   calculate_pattern_lines("^$", true)
  -- end)
  -- vim.keymap.set("n", "}", function()
  --   calculate_pattern_lines("^$", false)
  -- end)

  vim.keymap.set("n", "gg", function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    require("neoscroll").scroll(-current_line, true, 50)
  end)
  vim.keymap.set("n", "G", function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local num_lines = vim.api.nvim_buf_line_count(0)
    require("neoscroll").scroll(num_lines - current_line, true, 50)
  end)

  require("neoscroll.config").set_mappings({
    -- https://github.com/karb94/neoscroll.nvim/issues/55
    -- ["{"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
    -- ["}"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
    -- ["<C-y>"] = { "scroll", { "-vim.wo.scroll", "false", "0" } },
    -- ["<C-e>"] = { "scroll", { "vim.wo.scroll", "false", "0" } },
    -- https://github.com/karb94/neoscroll.nvim/issues/50
    -- ["<ScrollWheelUp>"] = { "scroll", { "-0.10", "false", "50" } },
    -- ["<ScrollWheelDown>"] = { "scroll", { "0.10", "false", "50" } },
  })
  -- vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelUp>", "<C-y>")
  -- vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelDown>", "<C-e>")
end

return M
