-- https://github.com/nvim-treesitter/nvim-treesitter --

return function()
	require'nvim-treesitter.configs'.setup {
		ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			indent = true,
		},
	}
	-- Folding (need to set foldminlines and foldnestmax)
	-- set foldmethod=expr
	-- set foldexpr=nvim_treesitter#foldexpr()
end
