-- https://github.com/folke/zen-mode.nvim --
-- NOTE: barbar disappears https://github.com/folke/zen-mode.nvim/issues/21

return function()
  local toggle_functions = function()
    -- TODO: force off on_open, restore previous state on_close
    -- [[ gitsigns ]]
    require("gitsigns").toggle_numhl()
    -- require("gitsigns").toggle_current_line_blame()

    -- [[ LSP diagnostics ]]
    vim.cmd(":silent! lua require'toggle_lsp_diagnostics'.toggle_virtual_text()<CR>")
    vim.cmd(":silent! lua require'toggle_lsp_diagnostics'.toggle_underline()<CR>")

    -- [[ todo-comment ]]
    -- SEE: https://github.com/folke/todo-comments.nvim/issues/27

    -- [[ toggle sidecolumn? ]]
    -- require("utils").toggle_signcolumn()
  end

  -- Zen mode
  require("zen-mode").setup({
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = false },
    },
    on_open = function(win)
      toggle_functions()
    end,
    on_close = function()
      toggle_functions()
    end,
  })
end
