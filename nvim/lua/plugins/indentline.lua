-- https://github.com/lukas-reineke/indent-blankline.nvim --

return function()
  require("indent_blankline").setup({
    char = "▏",
    show_current_context = true,
    show_current_context_start = true,
    use_treesitter = true,
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "if",
      "^while",
      "jsx_element",
      "^for",
      "for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
    -- exclude vim which key
    filetype_exclude = {
      "dashboard",
      "terminal",
      "packer",
      "help",
      "floaterm",
    },
  })

  -- Context line colours
  vim.opt.termguicolors = true
  -- #E06C75
  -- #E5C07B
  -- #98C379
  -- #56B6C2
  -- #61AFEF
  -- #C678DD

  -- NOTE: moved to material.nvim theme config as highlight override
  -- vim.cmd([[highlight IndentBlanklineContextChar guifg=#C678DD gui=nocombine]])
end
