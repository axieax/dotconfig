local M = {}

function M.config()
  require("indent_blankline").setup({
    char = "▏",
    show_current_context = true,
    show_current_context_start = true,
    use_treesitter = true,
    -- TODO: incorporate more default g:indent_blankline_context_patterns?
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
      "terminal",
      "packer",
      "alpha",
      "help",
      "man",
      "lspinfo",
      "toggleterm",
      "glowpreview",
      "lsp-installer",
      "checkhealth",
      "aerial",
      "",
    },
    -- char_highlight_list = {
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent2",
    --   "IndentBlanklineIndent3",
    --   "IndentBlanklineIndent4",
    --   "IndentBlanklineIndent5",
    --   "IndentBlanklineIndent6",
    -- },
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
  -- vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#C678DD", nocombine = true }) -- NOTE: doesn't work yet
  -- vim.cmd.highlight("IndentBlanklineContextChar guifg=#C678DD gui=nocombine")
end

return M
