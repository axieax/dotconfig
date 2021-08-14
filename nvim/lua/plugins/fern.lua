return function ()
	-- Devicons
	vim.cmd([[
	augroup my-glyph-palette
	autocmd! *
	autocmd FileType fern call glyph_palette#apply()
	autocmd FileType nerdtree,startify call glyph_palette#apply()
	augroup END
	]])
	vim.g["fern#renderer"] = { "nerdfont" } -- devicons?

	vim.cmd([[
	function! s:init_fern() abort
	nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
	endfunction

	augroup fern-custom
	autocmd! *
	autocmd FileType fern call s:init_fern()
	augroup END
	]])
end
