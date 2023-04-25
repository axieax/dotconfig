local M = {}

-- TODO: fold preview on right click

local function git_hunk_actions()
  local actions = require("gitsigns").get_actions()
  local items = {}
  for name, action in pairs(actions) do
    table.insert(items, { name = name, action = action })
  end

  vim.ui.select(items, {
    prompt = "Git hunk actions",
    format_item = function(item)
      return item.name:sub(1, 1):upper() .. item.name:gsub("_", " "):sub(2)
    end,
  }, function(item)
    if item ~= nil then
      item.action()
    end
  end)
end

function M.config()
  local builtin = require("statuscol.builtin")
  builtin.diagnostic_click = function(args)
    if args.button == "l" then
      vim.diagnostic.open_float({ border = "rounded" })
    elseif args.button == "m" then
      require("axie.plugins.lsp.code_actions").native(true)
    elseif args.button == "r" then
      require("axie.plugins.lsp.code_actions").native()
    end
  end

  require("statuscol").setup({
    relculright = true,
    segments = {
      {
        sign = { name = { "Dap*" }, maxwidth = 1, auto = true },
        click = "v:lua.ScSa",
      },
      {
        sign = { name = { "Diagnostic", "todo*" }, maxwidth = 1, auto = true },
        click = "v:lua.ScSa",
      },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      {
        text = {
          function(args)
            local result = builtin.foldfunc(args)
            return result == "" and " " or result
          end,
        },
        click = "v:lua.ScFa",
      },
      {
        sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        click = "v:lua.ScSa",
      },
    },
    clickmod = "c",
    clickhandlers = {
      Lnum = function(args)
        if args.button == "l" then
          -- NOTE: conditional breakpoint with `clickmod`
          builtin.toggle_breakpoint(args)
        elseif args.button == "m" then
          git_hunk_actions()
        elseif args.button == "r" then
          require("axie.plugins.lsp.code_actions").native()
        end
      end,
    },
  })
end

return M
