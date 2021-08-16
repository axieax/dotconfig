-- https://github.com/nvim-treesitter/nvim-treesitter --
-- https://github.com/nvim-treesitter/playground --

return function()
	local vim_apply = require("utils").vim_apply
	require'nvim-treesitter.configs'.setup {
		-- Treesitter
		ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			indent = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gs",
				node_incremental = "gm",
				node_decremental = "gn",
				scope_incremental = "gs",
			},
		},
		-- Playground
		playground = {
			enable = true,
		},
		query_linter = {
			enable = true,
			use_virtual_text = true,
			-- lint_events = {"BuffWrite", "CursorHold"},
		}
	}

	-- Folding (zopen/zclose, zReveal/zMinimise)
	-- TODO: fold function keybind (use TS to parse and fold to function)
	vim_apply(vim.o, {
		foldmethod = "expr",
		foldexpr = "nvim_treesitter#foldexpr()",
		foldnestmax = 3, -- maximum nesting of folds
		-- foldminlines = 1, -- min lines required for a fold (default)
		foldlevel = 0, -- default levels folded
		foldenable = false, -- don't fold by default
	})

end
