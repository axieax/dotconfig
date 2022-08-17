local M = {}

function M.config()
  require("focus").setup({
    -- TEMP: https://github.com/beauwilliams/focus.nvim/issues/82
    autoresize = false,
    cursorline = false,
    number = false,
    signcolumn = false,
    colorcolumn = { enable = true, width = tonumber(vim.o.colorcolumn) },
    excluded_filetypes = { "toggleterm", "qf", "help", "Mundo" },
  })
end

return M
