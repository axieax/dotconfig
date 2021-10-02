-- https://github.com/vim-test/vim-test --
-- https://github.com/rcarriga/vim-ultest --
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
  vim.g["test#python#runner"] = "pytest"
  vim.g["test#java#runner"] = "gradletest"
end

return M
