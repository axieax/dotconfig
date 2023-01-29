local M = {}

-- 1 for just status, 2 for reason, 3 for topmost stack trace, etc.
local ERROR_LIMIT = 3

function M.test_summary()
  local notify = require("axie.utils").notify
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    -- find result buffer
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    if buf_name:find("[dap-repl]", 0, 1) then
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
  notify("No tests found 😢", vim.log.levels.ERROR)
end

M.keys = {
  {
    "<Space>tt",
    function()
      require("neotest").run.run()
    end,
    desc = "Test nearest",
  },
  {
    "<Space>tT",
    function()
      require("neotest").run.run({ strategy = "dap" })
    end,
    desc = "Debug nearest",
  },
  {
    "<Space>tf",
    function()
      require("neotest").run.run(vim.fn.expand("%"))
    end,
    desc = "Test file",
  },
  {
    "<Space>tF",
    function()
      require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
    end,
    desc = "Debug file",
  },
  {
    "<Space>tr",
    function()
      require("neotest").run.run_last()
    end,
    desc = "Test last",
  },
  {
    "<Space>tR",
    function()
      require("neotest").run.run_last({ strategy = "dap" })
    end,
    desc = "Debug last",
  },
  {
    "<Space>t;",
    function()
      -- TODO: enter = true
      require("neotest").summary.toggle()
    end,
    desc = "Test summary",
  },
  {
    "<Space>tp",
    function()
      require("neotest").output.open()
    end,
    desc = "Test output",
  },
  {
    "<Space>tP",
    function()
      require("neotest").output_panel.toggle()
    end,
    desc = "Test output panel",
  },
  {
    "<Space>tq",
    function()
      require("neotest").run.stop()
    end,
    desc = "Quit test",
  },
  {
    "[t",
    function()
      require("neotest").jump.prev({ status = "failed" })
    end,
    desc = "Previous failed test",
  },
  {
    "]t",
    function()
      require("neotest").jump.next({ status = "failed" })
    end,
    desc = "Next failed test",
  },
  {
    "[T",
    function()
      require("neotest").jump.prev()
    end,
    desc = "Previous test",
  },
  {
    "]T",
    function()
      require("neotest").jump.next()
    end,
    desc = "Next test",
  },
}

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
      python = "/usr/local/bin/python3",
      runner = "pytest",
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
    else
      require("axie.utils").notify(string.format("Could not load neotest-%s adapter", adapter), vim.log.levels.ERROR)
    end
  end

  table.insert(adapters, require("neotest-vim-test")({ ignore_file_types = adapter_filetypes }))

  require("neotest").setup({
    adapters = adapters,
    -- floating = { options = { winblend = 80 } },
  })
end

return M
