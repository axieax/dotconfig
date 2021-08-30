-- https://github.com/mhartington/formatter.nvim --
-- SETUP: add (yarn global bin) to path
-- LUA: sudo pacman -S stylua
-- PRETTIER: yarn global add prettier
-- CLANG_FORMAT: yarn global add clang_format
-- PYTHON: pip install black

return function()
	-- Format on save
	vim.api.nvim_exec(
		[[
		augroup fmt
		autocmd!
		autocmd BufWritePre * undojoin | Neoformat
		augroup END
		]],
		true
	)
end
