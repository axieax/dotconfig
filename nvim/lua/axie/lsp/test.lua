-- https://github.com/vim-test/vim-test --
-- https://github.com/rcarriga/vim-ultest --
-- TODO: java functions separate keybindings in ftplugin or on_attach?

local M = {}

function M.display()
  -- TODO: https://github.com/rcarriga/nvim-notify/issues/43
  local notify = require("axie.utils").notify
  -- get buffers
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    -- find result buffer
    local buf_name = vim.fn.bufname(bufnr)
    if buf_name == "[dap-repl]" then
      -- display notification
      local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 1, -1, false)
      notify(table.concat(buf_lines, "\n"))
      return
    end
  end
  notify("No tests found 😢", "error")
end

function M.display_delayed()
  -- NOTE: automatically activates after a fixed timeout (regardless of test time)
  -- TODO: keep trying until [dap-repl] found?
  vim.defer_fn(M.display, 2000)
end

function M.custom_test_method()
  local ft = vim.bo.filetype
  if ft == "python" then
    require("dap-python").test_method()
  elseif ft == "java" then
    require("jdtls").test_nearest_method()
  end
  M.display_delayed()
end

function M.custom_test_class()
  local ft = vim.bo.filetype
  if ft == "python" then
    require("dap-python").test_class()
  elseif ft == "java" then
    require("jdtls").test_class()
  end
  M.display_delayed()
end

function M.custom_test_summary()
  local ft = vim.bo.filetype
  if ft == "java" then
    -- NOTE: summary not persistent
    M.display()
  else
    vim.cmd("<CMD>UltestSummary<CR>")
  end
end

function M.setup()
  vim.g.ultest_use_pty = 1
  vim.g["test#python#runner"] = "pytest"
  vim.g["test#java#runner"] = "gradletest"
end

return M
