-- https://github.com/vim-test/vim-test --
-- https://github.com/rcarriga/vim-ultest --
-- TODO: setup test debug --

return function()
  vim.g.ultest_use_pty = 1
  local map = require("utils").map
  map({ "n", "<space>tf", "<cmd>:Ultest<CR>" })
  map({ "n", "<space>tF", "<cmd>:UltestDebug<CR>" })

  map({ "n", "<space>tt", "<cmd>:UltestNearest<CR>" })
  map({ "n", "<space>tT", "<cmd>:UltestDebugNearest<CR>" })

  map({ "n", "<space>tp", "<cmd>:UltestOutput<CR>" })
  map({ "n", "<space>t;", "<cmd>:UltestSummary<CR>" })

  map({ "n", "<space>tv", "<cmd>:TestVisit<CR>" })

  map({ "n", "]t", "<cmd>:call ultest#positions#next()<CR>" })
  map({ "n", "[t", "<cmd>:call ultest#positions#prev()<CR>" })

  vim.g["test#python#runner"] = "pytest"
  -- vim.g["test#java#runner"] = "gradlerunner"
end
