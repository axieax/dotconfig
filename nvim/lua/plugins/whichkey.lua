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
      },
      -- TODO: set up g for Telescope git_*
    },
    -- TODO: g, ][]
    ["%["] = {
      name = "+previous",
      g = { "git hunk" },
    },
  })
end
