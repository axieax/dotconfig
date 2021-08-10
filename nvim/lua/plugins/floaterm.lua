-- https://github.com/voldikss/vim-floaterm --

-- Floaterm settings
vim_apply(vim.g, {
  floaterm_wintitle = 0,
  floaterm_width = 0.8,
  floaterm_height = 0.8,
  floaterm_autoclose = 1,
  floaterm_autoinsert = 1,
})

-- Floaterm keybinds
vim_apply(vim.g, {
  floaterm_keymap_toggle = "<F1>",
  floaterm_keymap_prev = "<F2>",
  floaterm_keymap_next = "<F3>",
  floaterm_keymap_new = "<F4>",
})
