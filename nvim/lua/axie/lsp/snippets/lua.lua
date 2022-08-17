local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

local snippets, autosnippets = {}, {}

-- Packer use

--[[ TEST
  use https://github.com/ziontee113/syntax-tree-surfer
]]

local function regex_capture(group)
  return function(_, snip)
    return snip.captures[group]
  end
end

local packer_use = s(
  {
    trig = "use https://github%.com/([%w-%._]+)/([%w-%._]+)\\",
    regTrig = true,
    hidden = true,
  },
  fmt('use({}"{}/{}"{})', {
    -- start
    c(1, { t(""), t({ "{", "  " }) }),
    -- org
    f(regex_capture(1)),
    -- repo
    f(regex_capture(2)),
    -- end based on start
    d(2, function(args, snip)
      local arg = args[1][1]
      local ret_node = t(arg)
      if arg == "{" then
        local plugin_name = snip.captures[2]
        plugin_name = string.gsub(plugin_name, "nvim", ""):gsub("[^%w]", "")
        ret_node = c(1, {
          -- no config
          t({ ",", "}" }),
          -- require config from plugins directory
          t({
            ",",
            string.format([[  config = require("axie.plugins.%s"),]], plugin_name),
            "}",
          }),
          -- empty anonymous config
          t({
            ",",
            "  config = function()",
            "  end,",
            "}",
          }),
          -- anonymous config with empty setup options
          t({
            ",",
            "  config = function()",
            string.format([[    require("%s").setup()]], plugin_name),
            "  end,",
            "}",
          }),
          -- anonymous config with setup options
          t({
            ",",
            "  config = function()",
            string.format([[    require("%s").setup({]], plugin_name),
            "    })",
            "  end,",
            "}",
          }),
        })
      end

      return sn(1, ret_node)
    end, { 1 }),
  })
)
table.insert(autosnippets, packer_use)

local mod = s(
  "mod",
  fmt(
    [[
    local {} = {{}}
    {}
    return {}
    ]],
    {
      i(1, "M"),
      c(2, {
        t(""),
        fmt(
          [[


            function {}.config(){}
            end

          ]],
          { rep(ai[1]), i(1) }
        ),
        fmt(
          [[


            function {}.setup(){}
            end

            function {}.config(){}
            end

          ]],
          { rep(ai[1]), i(1), rep(ai[1]), i(2) }
        ),
      }),
      c(3, {
        rep(ai[1]),
        fmt("setmetatable({}, {{{}}})", { rep(ai[1]), i(1) }),
      }),
    }
  )
)
table.insert(snippets, mod)

return snippets, autosnippets
