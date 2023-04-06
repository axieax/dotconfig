local M = {}

M.keys = { { "\\i", "<Cmd>IndentBlankLineToggle<CR>", desc = "Toggle indent line" } }

M.opts = {
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
    "alpha",
    "help",
    "man",
    "lspinfo",
    "toggleterm",
    "glowpreview",
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
}

return M
