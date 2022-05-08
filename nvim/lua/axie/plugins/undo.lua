-- https://github.com/simnalamburt/vim-mundo --

return function()
  vim.g.mundo_auto_preview_delay = 0
  vim.g.mundo_playback_delay = 100

  vim.keymap.set("n", "<Space>u", "<Cmd>MundoToggle<CR>", { desc = "Undo Tree" })
end
