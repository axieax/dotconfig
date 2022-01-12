-- https://github.com/monaqa/dial.nvim --
-- TODO: migrate to https://github.com/monaqa/dps-dial.vim ? --

return function()
  local dial = require("dial")

  local extra_augends = {
    "markup#markdown#header",
    "date#[%H:%M:%S]",
  }

  local custom_augends = {
    boolean = dial.common.enum_cyclic({ strlist = { "true", "false" } }),
    Boolean = dial.common.enum_cyclic({ strlist = { "True", "False" } }),
    -- on = dial.common.enum_cyclic({ strlist = { "on", "off" } }),
    -- ON = dial.common.enum_cyclic({ strlist = { "ON", "OFF" } }),
    -- On = dial.common.enum_cyclic({ strlist = { "On", "Off" } }),
    -- direction = dial.common.enum_cyclic({ strlist = { "north", "south", "west", "east" } }),
    -- Direction = dial.common.enum_cyclic({ strlist = { "North", "South", "West", "East" } }),
    greater = dial.common.enum_cyclic({ strlist = { ">", "<" } }),
    -- equal = dial.common.enum_cyclic({ strlist = { "==", "!=" } }),
    -- Equal = dial.common.enum_cyclic({ strlist = { "===", "!==" } }),
    -- greaterEqual = dial.common.enum_cyclic({ strlist = { ">=", "<=" } }),
    -- selfAdd = dial.common.enum_cyclic({ strlist = { "++", "--" } }),
  }

  -- register custom augends
  for k, v in pairs(custom_augends) do
    local augend_name = "custom#" .. k
    dial.augends[augend_name] = v
    table.insert(extra_augends, augend_name)
  end

  -- extend capabilities
  vim.list_extend(dial.config.searchlist.normal, extra_augends)
  vim.list_extend(dial.config.searchlist.visual, extra_augends)
end
