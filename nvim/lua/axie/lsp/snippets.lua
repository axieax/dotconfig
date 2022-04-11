local M = {}

-- TODO: choice node vim.ui.select https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup

function M.setup()
  -- load snippets from rtp (rafamadriz/friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()

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
  vim.cmd([[
    inoremap <silent> <buffer> <c-l> <CMD>lua if require'luasnip'.expand_or_jumpable() then require'luasnip'.expand_or_jump() end<CR>
    snoremap <silent> <buffer> <c-l> <CMD>lua if require'luasnip'.expand_or_jumpable() then require'luasnip'.expand_or_jump() end<CR>
    inoremap <silent> <buffer> <c-h> <CMD>lua if require'luasnip'.jumpable(-1) then require'luasnip'.jump(-1) end<CR>
    snoremap <silent> <buffer> <c-h> <CMD>lua if require'luasnip'.jumpable(-1) then require'luasnip'.jump(-1) end<CR>
    inoremap <silent> <buffer> <c-k> <CMD>lua if require'luasnip'.choice_active() then require'luasnip'.change_choice(1) end<CR>
    inoremap <silent> <buffer> <c-j> <CMD>lua if require'luasnip'.choice_active() then require'luasnip'.change_choice(-1) end<CR>
  ]])
  -- vim.keymap.set({ "i", "s" }, "<c-l>", function()
  --   if ls.expand_or_jumpable() then
  --     ls.expand_or_jump()
  --   end
  -- end, {
  --   silent = true,
  -- })
  -- vim.keymap.set({ "i", "s" }, "<c-h>", function()
  --   if ls.jumpable(-1) then
  --     ls.jump(-1)
  --   end
  -- end, {
  --   silent = true,
  -- })
  -- vim.keymap.set("i", "<c-j>", function()
  --   if ls.choice_active() then
  --     ls.change_choice(-1)
  --   end
  -- end, {
  --   silent = true,
  -- })
  -- vim.keymap.set("i", "<c-k>", function()
  --   if ls.choice_active() then
  --     ls.change_choice(1)
  --   end
  -- end, {
  --   silent = true,
  -- })

  -- register custom snippets
  require("axie.lsp.snippets").custom_snippets()
end

function M.custom_snippets()
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local c = ls.choice_node
  local rep = require("luasnip.extras").rep
  local fmt = require("luasnip.extras.fmt").fmt

  -- Prettier ignore snippet
  ls.add_snippets("markdown", {
    s("ignore", t("<!-- prettier-ignore -->")),
  })

  ls.add_snippets("all", {
    s(
      "test",
      c(1, {
        t("test1"),
        t("test2"),
        t("test3"),
        t("test4"),
        t("test5"),
      })
    ),
  })

  -- Competitive programming template for C++
  ls.add_snippets("cpp", {
    s("cpt", {
      t({
        "#include <bits/stdc++.h>",
        "",
        "using namespace std;",
        "",
        "#define ll long long",
        "#define ld long double",
        "#define PI M_PI",
        "#define INF 1e9",
        '#define debug(x) cout << #x << ": " << x << endl;',
        "",
        "void solve() {",
        "  ",
      }),
      i(1, "// TODO"), -- cursor placement on snippet expansion
      -- TODO: add choice node for commented lines?
      t({
        "",
        "}",
        "",
        "int main() {",
        "	// optimise read/write",
        "	ios_base::sync_with_stdio(0);",
        "	cin.tie(0); cout.tie(0);",
        "",
        "	// test cases",
        "	int tc = 1;",
        "	// cin >> tc;",
        "	for (int t = 1; t <= tc; ++t) {",
        '		// cout << "Case #" << t << ": ";',
        "		solve();",
        "	}",
        "}",
      }),
    }),
  })
end

return M
