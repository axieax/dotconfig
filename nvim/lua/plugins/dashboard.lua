-- https://github.com/glepnir/dashboard-nvim --

return function()
	vim.g.dashboard_default_executive = "telescope"
	-- Telescope bindings
	-- vim.g.dashboard_custom_shortcut = {
	-- 	last_session = "SPC s l",
	-- }
	-- Customisations
	vim.g.dashboard_custom_header = {
		[[   _____  ____  ___.______________   _____  ____  ___]],
		[[  /  _  \ \   \/  /|   \_   _____/  /  _  \ \   \/  /]],
		[[ /  /_\  \ \     / |   ||    __)_  /  /_\  \ \     / ]],
		[[/    |    \/     \ |   ||        \/    |    \/     \ ]],
		[[\____|__  /___/\  \|___/_______  /\____|__  /___/\  \]],
		[[        \/      \_/            \/         \/      \_/]],
		[[                                                     ]],
		[[     > Press [s] to restore your last session <      ]],
	}
	vim.g.dashboard_custom_footer = {
		' https://github.com/axieax/',
	}

	-- space f r for find recent
	-- Telescope frecency for recent
	
	-- Session persistence
	-- NOTE: barbar weird lol
	vim.cmd("autocmd VimLeave * :SessionSave")
end
