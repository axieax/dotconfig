-- https://github.com/monaqa/dial.nvim --
return function()
  -- s above x
  local map = require("utils").map
  map({ "n", "<C-s>", "<Plug>(dial-increment)" })
  map({ "n", "<C-x>", "<Plug>(dial-decrement)" })
  map({ "v", "<C-s>", "<Plug>(dial-increment)" })
  map({ "v", "<C-x>", "<Plug>(dial-decrement)" })
  map({ "v", "g<C-s>", "<Plug>(dial-increment-additional)" })
  map({ "v", "g<C-x>", "<Plug>(dial-decrement-additional)" })
end
