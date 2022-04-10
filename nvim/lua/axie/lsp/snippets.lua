local M = {}

function M.setup()
  -- load snippets from rtp (rafamadriz/friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()
  require("axie.lsp.snippets").custom_snippets()
end

function M.custom_snippets()
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local rep = require("luasnip.extras").rep
  local fmt = require("luasnip.extras.fmt").fmt

  ls.add_snippets("markdown", {
    s("ignore", t("<!-- prettier-ignore -->")),
  })

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
      i(1), -- cursor placement on snippet expansion
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
