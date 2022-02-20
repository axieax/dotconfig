-- https://github.com/monaqa/dial.nvim --

return function()
  local augend = require("dial.augend")

  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.octal,
      augend.integer.alias.binary,
      augend.hexcolor.new({}),
      -- augend.constant.alias.alpha,
      -- augend.constant.alias.Alpha,
      augend.semver.alias.semver,
      augend.date.alias["%H:%M:%S"],
      -- TODO: markup#markdown#header
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

  local map = require("axie.utils").map
  map({ "n", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "n", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "v", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "g<C-a>", "g<Plug>(dial-increment)", noremap = false })
  map({ "v", "g<C-x>", "g<Plug>(dial-decrement)", noremap = false })
end
