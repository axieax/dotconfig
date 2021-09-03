-- https://github.com/folke/which-key.nvim --

return function()
  local wk = require("which-key")
  -- Config
  wk.setup({
    layout = {
      align = "center",
    },
  })

  -- mappings
  wk.register({
    ["<space>"] = {
      name = "Space",
      d = {
        name = "+debug",
        -- TODO
      },
      t = {
        name = "+test",
      },
      l = {
        name = "+lsp",
        -- TODO
      },
      f = {
        name = "+telescope",
        b = { "search buffers" },
        c = { "search config" },
        d = { "document diagnostics" },
        D = { "workspace diagnostics" },
        e = { "file explorer" },
        f = { "find files" },
        h = { "help" },
        o = { "vim options" },
        g = { "live grep" },
        r = { "old_files" },
        t = { "theme" },
        m = { "search manual" },
        s = { "spelling" },
        k = { "find keymaps" },
        ["/"] = { "search history" },
        [";"] = { "command history" },
        -- TODO: grep_string
      },
      -- TODO: set up g for Telescope git_*
      g = {
        name = "+git",
        [";"] = { "git blame toggle" },
        g = { "<cmd>:FloatermNew lazygit<CR>", "lazygit" },
        h = { "git stage hunk" },
        r = { "git reset hunk" },
        R = { "git reset buffer" },
        d = { "git diff preview" },
        u = { "git stage hunk undo" },
        s = { "git stash" },
        b = { "git branches" },
        c = { "git buffer commits" },
        C = { "git repo commits" },
        y = { "git yank reference url" },
        Y = { "git yank repo url" },
        w = { "git browse reference url" },
        W = { "git browse repo url" },
        ["?"] = { "git status" },
      },
    },
    ["["] = {
      name = "+previous",
      g = { "Previous git hunk" },
      d = { "Previous diagnostic" },
      t = { "Previous test" },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = { "Next diagnostic" },
      t = { "Next test" },
    },
    h = {
      name = "+hop",
      c = { "<cmd>:HopChar1<CR>", "char 1" },
      C = { "<cmd>:HopChar2<CR>", "Char 2" },
      w = { "<cmd>:HopWord<CR>", "word" },
      l = { "<cmd>:HopLine<CR>", "line" },
      h = { "<cmd>:HopPattern<CR>", "pattern" },
    },
  })
end
