local M = {}

function M.setup()
  vim.keymap.set({ "n", "v" }, "<C-a>", "<Plug>(dial-increment)")
  vim.keymap.set({ "n", "v" }, "<C-x>", "<Plug>(dial-decrement)")
  vim.keymap.set("v", "g<C-a>", "g<Plug>(dial-increment)")
  vim.keymap.set("v", "g<C-x>", "g<Plug>(dial-decrement)")
end

function M.config()
  local this = require("axie.plugins.dial")
  local cyclic_words = this.cyclic_words
  local cyclic_symbols = this.cyclic_symbols
  local cyclic_dates = this.cyclic_dates

  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.hexcolor.new({}),
      augend.paren.alias.quote,
      augend.paren.alias.lua_str_literal,
      augend.paren.alias.rust_str_literal,
      augend.paren.alias.brackets,
      -- augend.constant.alias.alpha,
      -- augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.misc.alias.markdown_header,
      cyclic_dates("%-H:%M", "min"),
      cyclic_dates("%-I:%M", "min"),
      cyclic_dates("%-d/%-m/%y", "day"),
      cyclic_dates("%-d/%-m/%Y", "day"),
      cyclic_words({ "true", "false" }),
      cyclic_words({ "on", "off" }),
      cyclic_words({ "north", "east", "south", "west" }),
      cyclic_words({ "and", "or" }),
      cyclic_symbols({ "&&", "||" }),
      cyclic_symbols({ "==", "!=" }),
      cyclic_symbols({ "===", "!==" }),
      cyclic_symbols({ ">", "<" }),
      cyclic_symbols({ ">=", "<=" }),
      cyclic_symbols({ "+=", "-=", "*=", "/=", "//=", "%=" }),
      cyclic_symbols({ "++", "--" }),
    },
  })
end

-- case_insensitive: lowercase, uppercase, lowercase with first letter uppercase
-- strict_casing = not case_insensitive
function M.cyclic_words(elements, strict_casing)
  local augend = require("dial.augend")
  return augend.constant.new({
    elements = elements,
    word = true,
    cyclic = true,
    preserve_case = not strict_casing,
  })
end

function M.cyclic_symbols(elements)
  local augend = require("dial.augend")
  return augend.constant.new({
    elements = elements,
    word = false,
    cyclic = true,
  })
end

function M.cyclic_dates(pattern, default_kind)
  local augend = require("dial.augend")
  return augend.date.new({
    pattern = pattern,
    default_kind = default_kind,
    only_valid = true,
  })
end

return M
