-- https://github.com/glacambre/firenvim --

return function()
  -- Setup config
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        takeover = "never", -- Autostart
        sync = "change", -- Autosave
        cmdline = "neovim",
      },
    },
  }

  -- Github buffers are Markdown
  vim.cmd("au BufEnter github.com_*.txt set filetype=markdown")

  -- TODO: setup Nerd Font glyphs
end
