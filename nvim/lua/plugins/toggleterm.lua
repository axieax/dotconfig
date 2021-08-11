-- https://github.com/akinsho/nvim-toggleterm.lua --
-- TODO: set up lazygit, repl etc.
-- NOTE: multiple terminals??

return function()
	require("toggleterm").setup {
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<C-\>]],
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		hide_numbers = true, -- hide the number column in toggleterm buffers
		persist_size = true,
		-- close_on_exit = false,
		direction = 'float', -- vertical, horizontal, float
		float_opts = {
			-- The border key is *almost* the same as 'nvim_win_open'
			-- see :h nvim_win_open for details on borders however
			-- the 'curved' border is a custom border type
			-- not natively supported but implemented in this plugin.
			border = 'single',
			-- width = <value>,
			-- height = <value>,
			winblend = 3,
			highlights = {
				border = "Normal",
				background = "Normal",
			}
		}
	}

	function _G.set_terminal_keymaps()
		-- Terminal normal mode
		map('t', '<esc>', [[<C-\><C-n>]])
	end

	-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

end

