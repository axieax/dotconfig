-- https://github.com/folke/zen-mode.nvim --
-- https://github.com/folke/twilight.nvim --

return function()
  local map = require("utils").map

  -- Zen mode
  require("zen-mode").setup({
    plugins = {
      twilight = { enabled = true },
      gitsigns = { enabled = false },
    },
    -- TODO: disable line blame and numhl
    on_open = function(win)
      -- require("gitsigns").toggle_current_line_blame()
      require("gitsigns").toggle_numhl()
      -- TODO: hide todo-comments sidebar
    end,
    on_close = function()
      require("gitsigns").toggle_numhl()
    end,
  })

  -- Twilight
  require("twilight").setup()
  -- NOTE: https://github.com/folke/twilight.nvim/issues/15#issuecomment-912146776
end
