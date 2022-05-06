-- https://github.com/L3MON4D3/LuaSnip --

-- TODO: choice node vim.ui.select https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup

return function()
  local ls = require("luasnip")
  local types = require("luasnip.util.types")

  ls.cleanup()
  ls.config.setup({
    -- dynamic snippet support
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,

    -- customise virtual text
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "", "DiagnosticSignWarn" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "⟵", "DiagnosticSignWarn" } },
        },
      },
    },
  })

  -- setup keybinds
  vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<c-h>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })
  vim.keymap.set("i", "<c-j>", function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end, { silent = true })
  vim.keymap.set("i", "<c-k>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })

  local lua_loader = require("luasnip.loaders.from_lua")
  vim.api.nvim_create_user_command("LuaSnipEdit", lua_loader.edit_snippet_files, {})
  vim.keymap.set("n", "\\S", "<CMD>LuaSnipEdit<CR>", { silent = true })

  -- load snippets from rtp (rafamadriz/friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()
  -- register custom snippets
  -- TODO: prevent multiple registrations with PackerCompile
  lua_loader.lazy_load({ paths = "~/dotconfig/nvim/lua/axie/lsp/snippets" })
end
