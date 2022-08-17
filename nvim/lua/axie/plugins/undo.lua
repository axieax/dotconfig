local M = {}

function M.setup()
  vim.keymap.set("n", "<Space>u", "<Cmd>MundoToggle<CR>", { desc = "Undo Tree" })
end

function M.config()
  vim.g.mundo_auto_preview_delay = 0
  vim.g.mundo_playback_delay = 100
end

return M
