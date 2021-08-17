-- https://github.com/nvim-telescope/telescope.nvim --
-- https://github.com/whatsthatsmell/dots/blob/master/public%20dots/vim-nvim/lua/joel/telescope/init.lua

--[[TODO
-- fzf native https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- image preview https://github.com/nvim-telescope/telescope-media-files.nvim
-- recent https://github.com/nvim-telescope/telescope-frecency.nvim
-- dap https://github.com/nvim-telescope/telescope-dap.nvim
-- lsp maps
-- current_buffer_fuzzy_find - control slash (<C-_>)
-- move top prompt above results, and all results ascending
--]]

return function()
	local map = require('utils').map
	-- map({"n", "<Space>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>"})
	map({"n", "<Space>ff", "<cmd>lua require('plugins.telescope.helpers').file_search(false)<cr>"})
	map({"n", "<Space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>"}) -- fw?
	map({"n", "<Space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>"}) -- ft?
	map({"n", "<Space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>"})
	map({"n", "<Space>fe", "<cmd>lua require('plugins.telescope.helpers').explorer()<cr>"})
	vim.cmd("autocmd VimEnter * lua require('plugins.telescope.helpers').file_search(true)")
	map({"n", ";", "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>"})
	-- NOTE: file browser currently can't go into folders? fzf?
	map({"n", "<C-_>", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>"}) -- control slash NOTE: inverse order
	-- TODO: config/bookmark search

	-- If find files opened from a directory buffer, change path to the directory instead (NERDTree)
	-- :Telescope file_browser (git repo, dir of current buffer if possible, normal) - better (can also do cwd=)
	-- space fe or fb?
	-- :Telescope find_files cwd=~/.config

	-- telescope setup mappings table - inside telescope overlay
	-- TODO: overwrite dotfiles? action for opening current file in native file explorer?
	require('telescope').setup {
		defaults = {
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.7,
				},
				vertical = {
					prompt_position = "top",
				}
			}
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
			}
		}
	}

	-- Extensions
	-- require('telescope').load_extension('fzf')

	-- NOTE: remove NERDTree? - can file browser create/move/delete files?

end
