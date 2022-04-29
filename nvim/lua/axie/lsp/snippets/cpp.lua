local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local isn = ls.indent_snippet_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

-- Competitive programming template
local template = s("cpt", {
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
  -- TODO: add choice node for commented lines? use ls.indent_snippet_node?
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
})

table.insert(snippets, template)

return snippets, autosnippets
