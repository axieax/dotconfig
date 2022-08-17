local M = {}

function M.setup()
  vim.keymap.set("i", "<a-l>", "<Plug>(TaboutMulti)")
  vim.keymap.set("i", "<a-h>", "<Plug>(TaboutBackMulti)")
end

function M.config()
  require("tabout").setup({
    tabkey = "",
    backwards_tabkey = "",
    act_as_tab = false,
  })
end

return M
