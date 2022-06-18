-- TODO: parse test cases only, and following line for errors (summary)

local M = {}

function M.dap_repl_summary()
  -- TODO: perhaps also a maximum number of errors to report? report length?
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

function M.binds()
  -- NORMAL
  vim.keymap.set("n", "<Space>tt", function()
    require("neotest").run.run()
  end, { desc = "Test nearest" })
  vim.keymap.set("n", "<Space>tT", function()
    require("neotest").run.run({ strategy = "dap" })
  end, { desc = "Test nearest (debug)" })
  vim.keymap.set("n", "<Space>tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Test file" })
  vim.keymap.set("n", "<Space>tF", function()
    require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
  end, { desc = "Test file (debug)" })
  vim.keymap.set("n", "<Space>tr", function()
    require("neotest").run.run_last()
  end, { desc = "Test last" })
  vim.keymap.set("n", "<Space>tR", function()
    require("neotest").run.run_last({ strategy = "dap" })
  end, { desc = "Test last (debug)" })
  vim.keymap.set("n", "<Space>t;", function()
    require("neotest").summary.toggle()
  end, { desc = "Test summary" })
  vim.keymap.set("n", "<Space>tp", function()
    require("neotest").output.open({ enter = true })
  end, { desc = "Test output" })

  -- jdtls
  local filetype_map = require("axie.utils").filetype_map
  filetype_map("java", "n", "<Space>tm", function()
    require("jdtls").test_nearest_method({
      after_test = require("axie.lsp.test").dap_repl_summary,
    })
  end, { desc = "Test method" })
  filetype_map("java", "n", "<Space>tc", function()
    require("jdtls").test_class({
      after_test = require("axie.lsp.test").dap_repl_summary,
    })
  end, { desc = "Test class" })
  filetype_map("java", "n", "<Space>t;", function()
    require("axie.lsp.test").dap_repl_summary()
  end, { desc = "Test summary" })
end

function M.setup()
  local adapters = {}
  for _, adapter in ipairs({ "go", "jest", "python", "plenary" }) do
    local ok, neotest_adapter = pcall(require, "neotest-" .. adapter)
    if ok then
      table.insert(adapters, neotest_adapter)
    end
  end

  -- TODO: change floating window background
  require("neotest").setup({ adapters = adapters })
end

return M
