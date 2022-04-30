-- https://github.com/simnalamburt/vim-mundo --

return function()
  -- Mundo
  vim.g.mundo_auto_preview_delay = 0
  vim.g.mundo_playback_delay = 100

  -- Persistent undo
  -- TODO: default undo limit up to buffer open
  if vim.fn.has("persistent_undo") == 1 then
    local target_path = vim.fn.expand("~/.undodir")
    if vim.fn.isdirectory(target_path) == 0 then
      vim.fn.mkdir(target_path)
    end
    vim.o.undodir = target_path
    vim.o.undofile = true
  end
end
