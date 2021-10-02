-- https://github.com/windwp/nvim-autopairs --
-- TODO: try https://github.com/windwp/nvim-autopairs#dont-add-pairs-if-the-next-char-is-alphanumeric

return function()
  require("nvim-autopairs").setup({
    -- insert mode "alt-e"
    -- NOTE: vim surround visual selection: S_ as well
    fast_wrap = {},
  })

  -- setup nvim-cmp
  require("nvim-autopairs.completion.cmp").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    auto_select = false, -- automatically select the first item
    insert = true, -- use insert confirm behavior instead of replace
    -- map_char = { -- modifies the function or method delimiter by filetypes
    --   all = "(",
    --   tex = "{",
    -- },
  })
end
