-- https://github.com/vim-test/vim-test --
-- https://github.com/rcarriga/vim-ultest --
-- TODO: java functions separate keybindings using utils.filetype_map
-- TODO: parse test cases only, and following line for errors (summary)
-- TODO: perhaps also a maximum number of errors to report?

local M = {}

local function dap_repl_summary()
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

local jdtls_test_options = { after_test = dap_repl_summary }

function M.custom_test_method()
  local ft = vim.bo.filetype
  if ft == "python" then
    -- NOTE: use Ultest instead
    require("dap-python").test_method()
  elseif ft == "java" then
    require("jdtls").test_nearest_method(jdtls_test_options)
  end
end

function M.custom_test_class()
  local ft = vim.bo.filetype
  if ft == "python" then
    -- NOTE: use Ultest instead
    require("dap-python").test_class()
  elseif ft == "java" then
    require("jdtls").test_class(jdtls_test_options)
  end
end

function M.custom_test_summary()
  local ft = vim.bo.filetype
  if ft == "java" then
    -- NOTE: summary not persistent
    dap_repl_summary()
  else
    vim.cmd("UltestSummary")
  end
end

function M.setup()
  vim.g.ultest_use_pty = 1
  vim.g["test#python#runner"] = "pytest"
  vim.g["test#java#runner"] = "gradletest"
end

return M
