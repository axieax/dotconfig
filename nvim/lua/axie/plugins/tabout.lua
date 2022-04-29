-- https://github.com/abecodes/tabout.nvim --

return function()
  require("tabout").setup({
    tabkey = "",
    backwards_tabkey = "",
    act_as_tab = false,
  })

  local map = require("axie.utils").map
  map({ "i", "<a-l>", "<Plug>(TaboutMulti)", noremap = false })
  map({ "i", "<a-h>", "<Plug>(TaboutBackMulti)", noremap = false })
end
