-- https://github.com/petertriho/nvim-scrollbar --

return function()
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
