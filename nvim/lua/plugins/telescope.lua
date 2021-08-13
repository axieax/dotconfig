-- https://github.com/nvim-telescope/telescope.nvim --
return function()
	local map = require('utils').map
	map({"n", "<Space>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>"})
	map({"n", "<Space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>"})
	map({"n", "<Space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>"}) -- ft?
	map({"n", "<Space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>"})
	-- NOTE: help preview too small

	-- live grep?

	-- Launch Telescope for directories (replacing netrw)
	-- NOTE: currently only works for opening first directory
	-- NOTE: no more :Explore functionality
	_G.directory_launch_telescope = function()
		local buffer_name = vim.api.nvim_buf_get_name(0)
		-- local buffer_name = vim.v.argv[2]
		if buffer_name and vim.fn.isdirectory(buffer_name) == 1 then
			-- Load dashboard in background
			vim.cmd("Dashboard")
			require("telescope.builtin").find_files({
				search_dirs = { buffer_name },
				hidden = true,
			})
		end
	end

	vim.cmd("autocmd VimEnter * lua directory_launch_telescope()")

end
