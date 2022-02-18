-- https://github.com/github/copilot.vim --

return function()
  local map = require("axie.utils").map
  map({ "i", "<C-a>", "copilot#Accept()", script = true, expr = true, silent = true })
  map({ "i", "<C-x>", "copilot#Dismiss()", script = true, expr = true, silent = true })
  vim.g.copilot_no_tab_map = true
end
