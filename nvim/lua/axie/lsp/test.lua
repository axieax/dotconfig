local M = {}

-- 1 for just status, 2 for reason, 3 for topmost stack trace, etc.
local ERROR_LIMIT = 3

function M.dap_repl_summary()
  local notify = require("axie.utils").notify
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    -- find result buffer
    local buf_name = vim.fn.bufname(bufnr)
    if buf_name == "[dap-repl]" then
      -- display notification
      local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 1, -1, false)

      local notification = ""
      local error_line_count = 0
      for _, line in ipairs(buf_lines) do
        if line:find("^[✔️❌]") then
          error_line_count = 0
        else
          -- Normal line within error block
          error_line_count = error_line_count + 1
        end

        if error_line_count < ERROR_LIMIT then
          notification = notification .. line .. "\n"
        end
      end

      notify(notification:sub(0, -2))
      return
    end
  end
  notify("No tests found 😢", "error")
end

function M.setup()
  -- general
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
    -- TODO: enter = true
    require("neotest").summary.toggle()
  end, { desc = "Test summary" })
  vim.keymap.set("n", "<Space>tp", function()
    require("neotest").output.open()
  end, { desc = "Test output" })
  vim.keymap.set("n", "<Space>tq", function()
    require("neotest").run.stop()
  end, { desc = "Test quit" })

  -- jump
  vim.keymap.set("n", "[t", function()
    require("neotest").jump.prev({ status = "failed" })
  end, { desc = "Previous test (failed)" })
  vim.keymap.set("n", "]t", function()
    require("neotest").jump.next({ status = "failed" })
  end, { desc = "Next test (failed)" })

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

function M.config()
  local adapter_config = {
    go = {
      filetypes = { "go" },
    },
    jest = {
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "coffee" },
    },
    python = {
      filetypes = { "python" },
    },
    plenary = {
      filetypes = { "lua" },
    },
    -- haskell = {
    --   filetypes = { "haskell" },
    -- },
  }

  local adapters = {}
  local adapter_filetypes = {}
  for adapter, opts in pairs(adapter_config) do
    local ok, neotest_adapter = pcall(require, "neotest-" .. adapter)
    if ok then
      table.insert(adapters, neotest_adapter(opts))
      vim.list_extend(adapter_filetypes, opts.filetypes)
    end
  end

  table.insert(adapters, require("neotest-vim-test")({ ignore_file_types = adapter_filetypes }))

  require("neotest").setup({
    adapters = adapters,
    -- floating = { options = { winblend = 80 } },
  })
end

return M
