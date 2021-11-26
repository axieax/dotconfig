-- https://github.com/simnalamburt/vim-mundo --

return function()
  -- Mundo
  vim.g.mundo_auto_preview_delay = 0
  vim.g.mundo_playback_delay = 100

  -- Persistent undo
  -- TODO: default undo limit up to buffer open
  vim.cmd([[
    if has("persistent_undo")
      let target_path = expand('~/.undodir')

      " create the directory and any parent directories
      " if the location does not exist.
      if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
      endif

      let &undodir=target_path
      set undofile
    endif
    ]])
end
