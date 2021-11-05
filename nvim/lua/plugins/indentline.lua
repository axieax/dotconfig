-- https://github.com/lukas-reineke/indent-blankline.nvim --

return function()
  require("indent_blankline").setup({
    char = "▏",
    show_current_context = true,
    show_current_context_start = true,
    -- exclude vim which key
    filetype_exclude = {
      "dashboard",
      "terminal",
      "packer",
      "help",
      "floaterm",
    },
  })
end
