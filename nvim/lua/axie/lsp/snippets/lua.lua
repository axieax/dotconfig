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
          -- normal braces end
          t({ ",", "}" }),
          -- braces end with require
          t({
            ",",
            string.format([[  config = require("axie.plugins.%s"),]], plugin_name),
            "}",
          }),
        })
      end

      return sn(1, ret_node)
    end, { 1 }),
  })
)
table.insert(autosnippets, packer_use)

return snippets, autosnippets
