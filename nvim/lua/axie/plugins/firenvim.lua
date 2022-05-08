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

  -- GitHub issues Markdown filetype
  require("axie.utils").override_filetype("github.com_*.txt", "markdown")

  -- TODO: setup Nerd Font glyphs (`guifont`)
  vim.opt.guifont = "JetBrains Mono"
end
