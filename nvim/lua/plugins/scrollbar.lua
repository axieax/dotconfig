-- https://github.com/petertriho/nvim-scrollbar --

return function()
  require("scrollbar").setup({
    handle = {
      -- TODO: link to CursorLine https://github.com/petertriho/nvim-scrollbar/issues/35
      color = "#302D41",
    },
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "terminal",
      "packer",
      "alpha",
      "lspinfo",
      "toggleterm",
    },
  })
  require("scrollbar.handlers.search").setup()
end
