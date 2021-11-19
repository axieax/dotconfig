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

  -- BUG: not working
  vim.cmd([[highlight IndentBlanklineContextChar guifg=#C678DD gui=nocombine]])
  vim.cmd([[
  augroup SetContextHighlights
    autocmd User PackerComplete,PackerCompileDone lua require("indent_blankline.utils").reset_highlights()
    autocmd User PackerComplete,PackerCompileDone highlight IndentBlanklineContextChar guifg=#C678DD gui=nocombine
  augroup END
  ]])
  -- vim.cmd(
  --   [[autocmd User PackerComplete,PackerCompileDone highlight IndentBlanklineContextChar guifg=#C678DD gui=nocombine]]
  -- )
end
