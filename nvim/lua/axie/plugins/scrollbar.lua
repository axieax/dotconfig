local M = {}

function M.config()
  require("scrollbar").setup({
    -- NOTE: disappears very quickly
    show_in_active_only = true,
    handle = { highlight = "CursorLine" },
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "terminal",
      "lspinfo",
      "alpha",
      "toggleterm",
    },
  })
  require("scrollbar.handlers.search").setup()
end

return M
