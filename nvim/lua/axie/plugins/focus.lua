-- https://github.com/beauwilliams/focus.nvim --

return function()
  require("focus").setup({
    cursorline = false,
    number = false,
    signcolumn = false,
    colorcolumn = { enable = true, width = tonumber(vim.o.colorcolumn) },
    excluded_filetypes = { "toggleterm", "qf", "help" },
  })
end
