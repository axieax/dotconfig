-- https://github.com/folke/zen-mode.nvim --
-- https://github.com/folke/twilight.nvim --

return function()
  local map = require("utils").map

  -- Zen mode
  require("zen-mode").setup({
    plugins = {
      twilight = { enabled = false },
      gitsigns = { enabled = false },
    },
    -- TODO: disable line blame and numhl
    on_open = function(win)
      -- require("gitsigns").toggle_current_line_blame()
      require("gitsigns").toggle_numhl()
    end,
    on_close = function()
      -- require("gitsigns").toggle_current_line_blame()
      require("gitsigns").toggle_numhl()
    end,
  })
  map({ "n", "<space>z", "<cmd>:ZenMode<CR>" })

  -- Twilight
  require("twilight").setup({
    dimming = {
      alpha = 0.9,
      color = { "#282c34" },
    },
  })
end
