local M = {}

-- TODO: choice node vim.ui.select https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup

M.keys = {
  {
    "<C-l>",
    function()
      local ls = require("luasnip")
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end,
    mode = { "n", "i", "s" },
  },
  {
    "<C-h>",
    function()
      local ls = require("luasnip")
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end,
    mode = { "n", "i", "s" },
  },
  {
    "<C-j>",
    function()
      local ls = require("luasnip")
      if ls.choice_active() then
        ls.change_choice(-1)
      end
    end,
    mode = { "n", "i" },
  },
  {
    "<C-k>",
    function()
      local ls = require("luasnip")
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end,
    mode = { "n", "i" },
  },
  {
    "\\S",
    function()
      require("luasnip.loaders.from_lua").edit_snippet_files()
    end,
  },
}

function M.config()
  local ls = require("luasnip")
  local types = require("luasnip.util.types")

  ls.config.setup({
    -- dynamic snippet support
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,

    -- customise virtual text
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "󰌵", "DiagnosticSignWarn" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "⟵", "DiagnosticSignWarn" } },
        },
      },
    },
  })

  -- load snippets from rtp (rafamadriz/friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()
  -- register custom snippets
  require("luasnip.loaders.from_lua").lazy_load({ paths = "~/dotconfig/nvim/lua/axie/plugins/lsp/snippets" })
end

return M
