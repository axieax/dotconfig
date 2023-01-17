local M = {}

-- NOTE: barbar disappears https://github.com/folke/zen-mode.nvim/issues/21

M.cmd = "ZenMode"

M.keys = { { "<Space>z", "<Cmd>ZenMode<CR>", desc = "Focus mode" } }

function M.config()
  local toggle_functions = function()
    -- TODO: force off on_open, restore previous state on_close
    -- [[ gitsigns ]]
    require("gitsigns").toggle_numhl()
    -- require("gitsigns").toggle_current_line_blame()

    -- [[ LSP diagnostics ]]
    require("axie.utils").toggle_diagnostics()

    -- [[ todo-comment ]]
    -- SEE: https://github.com/folke/todo-comments.nvim/issues/27

    -- [[ toggle sidecolumn? ]]
    -- require("axie.utils").toggle_signcolumn()
  end

  -- Zen mode
  require("zen-mode").setup({
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      -- diagnostics = { enabled = false }, -- NOTE: prefer custom diagnostics view
    },
    on_open = function(win)
      toggle_functions()
    end,
    on_close = function()
      toggle_functions()
    end,
  })
end

return M
