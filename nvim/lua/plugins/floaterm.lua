-- https://github.com/voldikss/vim-floaterm --
-- NOTE: exiting nvim will exit floaterm without warning
-- Set up keybinds for different orientations
-- [[C-\]]
-- TODO: set up floaterm list - https://github.com/voldikss/vim-floaterm#use-with-other-plugins
-- clap-floaterm

return function()
	vim_apply(vim.g, {
		-- Floaterm settings
		floaterm_wintitle = 0,
		floaterm_width = 0.8,
		floaterm_height = 0.8,
		floaterm_autoclose = 1,
		floaterm_autoinsert = 1,
		-- Floaterm keybinds
		floaterm_keymap_toggle = "<F1>",
		floaterm_keymap_prev = "<F2>",
		floaterm_keymap_next = "<F3>",
		floaterm_keymap_new = "<F4>",
	})
end
