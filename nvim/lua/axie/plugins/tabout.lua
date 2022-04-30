-- https://github.com/abecodes/tabout.nvim --

return function()
  require("tabout").setup({
    tabkey = "",
    backwards_tabkey = "",
    act_as_tab = false,
  })

  vim.keymap.set("i", "<a-l>", "<Plug>(TaboutMulti)")
  vim.keymap.set("i", "<a-h>", "<Plug>(TaboutBackMulti)")
end
