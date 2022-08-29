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

  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.hexcolor.new({}),
      -- augend.constant.alias.alpha,
      -- augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.date.alias["%H:%M:%S"],
      augend.misc.alias.markdown_header,
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

return M
