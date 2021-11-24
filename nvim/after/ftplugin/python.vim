:nmap <silent><buffer> [[ :lua require'nvim-treesitter.textobjects.move'.goto_previous_end('@parameter.inner')<CR>viq
:vmap <silent><buffer> [[ <esc>:lua require'nvim-treesitter.textobjects.move'.goto_previous_end('@parameter.inner')<CR>viq
:nmap <silent><buffer> ]] :lua require'nvim-treesitter.textobjects.move'.goto_next_start('@parameter.inner')<CR>viq
:vmap <silent><buffer> ]] <esc>:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@parameter.inner')<CR>viq
