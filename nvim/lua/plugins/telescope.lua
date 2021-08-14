-- https://github.com/nvim-telescope/telescope.nvim --
return function()
	local map = require('utils').map
	map({"n", "<Space>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>"})
	map({"n", "<Space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>"})
	map({"n", "<Space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>"}) -- ft?
	map({"n", "<Space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>"})
	-- NOTE: help preview too small

	-- If find files opened from a directory buffer, change path to the directory instead (NERDTree)

end
