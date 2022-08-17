local M = {}

function M.config()
  require("nvim-biscuits").setup({
    on_events = { "CursorMoved", "CursorMovedI" },
    toggle_keybind = "<Space><Space>",
    -- cursor_line_only = true,
    default_config = {
      max_length = 24,
      min_distance = 4,
      prefix_string = " ﬌ ",
    },
  })
end

return M
