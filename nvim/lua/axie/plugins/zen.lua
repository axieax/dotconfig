-- https://github.com/folke/zen-mode.nvim --
-- NOTE: barbar disappears https://github.com/folke/zen-mode.nvim/issues/21

local M = {}

function M.setup()
  vim.keymap.set("n", "<Space>z", "<Cmd>ZenMode<CR>", { desc = "zen mode" })
end

function M.config()
  local toggle_functions = function()
    -- TODO: force off on_open, restore previous state on_close
    -- [[ gitsigns ]]
    require("gitsigns").toggle_numhl()
    -- require("gitsigns").toggle_current_line_blame()

    -- [[ LSP diagnostics ]]
    local diagnostics = require("toggle_lsp_diagnostics")
    local echo = diagnostics.display_status
    diagnostics.display_status = function() end
    diagnostics.toggle_virtual_text()
    diagnostics.toggle_underline()
    diagnostics.display_status = echo

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
