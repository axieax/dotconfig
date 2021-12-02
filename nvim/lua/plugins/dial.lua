-- https://github.com/monaqa/dial.nvim --
-- TODO: migrate to https://github.com/monaqa/dps-dial.vim ? --

return function()
  local dial = require("dial")
  -- boolean toggle
  dial.augends["custom#boolean"] = dial.common.enum_cyclic({
    name = "boolean",
    strlist = { "true", "false" },
  })
  dial.augends["custom#Boolean"] = dial.common.enum_cyclic({
    name = "Boolean",
    strlist = { "True", "False" },
  })

  -- extend capabilities
  local extra_augmends = {
    "markup#markdown#header",
    "date#[%H:%M:%S]",
    "custom#boolean",
    "custom#Boolean",
  }
  for _, augmend in ipairs(extra_augmends) do
    table.insert(dial.config.searchlist.normal, augmend)
    table.insert(dial.config.searchlist.visual, augmend)
  end
end
