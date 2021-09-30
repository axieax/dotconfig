-- https://github.com/vim-test/vim-test --
-- https://github.com/rcarriga/vim-ultest --
-- TODO: setup test debug --
local M = {}

function M.custom_test_method()
  local ft = vim.bo.filetype
  if ft == "python" then
    require("dap-python").test_method()
  elseif ft == "java" then
    require("jdtls").test_nearest_method()
  end
end

function M.custom_test_class()
  local ft = vim.bo.filetype
  if ft == "python" then
    require("dap-python").test_class()
  elseif ft == "java" then
    require("jdtls").test_class()
  end
end

function M.setup()
  vim.g.ultest_use_pty = 1
  local map = require("utils").map
  map({ "n", "<space>tf", "<cmd>Ultest<CR>" })
  map({ "n", "<space>tF", "<cmd>UltestDebug<CR>" })

  map({ "n", "<space>tt", "<cmd>UltestNearest<CR>" })
  map({ "n", "<space>tT", "<cmd>UltestDebugNearest<CR>" })

  map({ "n", "<space>tp", "<cmd>UltestOutput<CR>" })
  map({ "n", "<space>t;", "<cmd>UltestSummary<CR>" })

  map({ "n", "<space>tv", "<cmd>TestVisit<CR>" })

  map({ "n", "]t", "<cmd>call ultest#positions#next()<CR>" })
  map({ "n", "[t", "<cmd>call ultest#positions#prev()<CR>" })

  -- Custom tests
  map({ "n", "<space>tm", "<cmd>lua require'lsp.test'.custom_test_method()<CR>" })
  map({ "n", "<space>tc", "<cmd>lua require'lsp.test'.custom_test_class()<CR>" })

  vim.g["test#python#runner"] = "pytest"
  vim.g["test#java#runner"] = "gradletest"
end

return M
