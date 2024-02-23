local M = {}

-- TODO: handle tab char
-- REF: https://github.com/lukas-reineke/indent-blankline.nvim/blob/master/lua/ibl/scope_languages.lua

M.keys = { { "\\i", "<Cmd>IBLToggle<CR>", desc = "Toggle indent line" } }

M.opts = {
  indent = { char = "▏" },
  -- TODO: incorporate more default g:indent_blankline_context_patterns?
  scope = {
    include = {
      node_type = {
        ["*"] = {
          --   "class",
          --   "return",
          --   "function",
          --   "method",
          if_statement = true,
          else_clause = true,
          for_statement = true,
          while_statement = true,
          argument_list = true,
          try_statement = true,
          except_clause = true,
          catch_statement = true,
          finally_statement = true,
          --   "jsx_element",
          --   "^object",
          --   "^table",
          --   "block",
          --   "jsx_element",
          --   "jsx_self_closing_element",
          --   "import_statement",
          --   "operation_type",
        },
        java = {
          switch_block = true,
          switch_rule = true,
        },
        python = {
          with_statement = true,
        },
        lua = {
          table_constructor = true,
        },
      },
    },
  },
}

return M
