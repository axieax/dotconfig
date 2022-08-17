local M = {}

function M.setup()
  vim.keymap.set({ "n", "v" }, "<C-a>", "<Plug>(dial-increment)")
  vim.keymap.set({ "n", "v" }, "<C-x>", "<Plug>(dial-decrement)")
  vim.keymap.set("v", "g<C-a>", "g<Plug>(dial-increment)")
  vim.keymap.set("v", "g<C-x>", "g<Plug>(dial-decrement)")
end

function M.config()
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
      augend.constant.new({
        elements = { "true", "false" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "True", "False" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "and", "or" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { ">", "<" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "==", "!=" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "===", "!==" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { ">=", "<=" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "+=", "-=", "*=", "/=", "//=", "%=" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "++", "--" },
        word = false,
        cyclic = true,
      }),
    },
  })

  -- OTHERS: on/off variants, north/east/south/west variants
end

return M
