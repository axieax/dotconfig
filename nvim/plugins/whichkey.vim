" https://github.com/liuchengxu/vim-which-key

" General settings
let g:which_key_use_floating_win = 0
let g:which_key_sep = ':'
" set timeoutlen=100

" Colours
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
	\| autocmd  BufLeave <buffer> set laststatus=2 noshowmode ruler

" Mappings
nnoremap <silent> <space> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <space> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
let g:which_key_map =  {}

" Startify mappings
let g:which_key_map['s'] = [ ':Startify'          , 'start' ]

" Codi mappings
let g:which_key_map.c = {
	\ 'name' : '+codi',
	\ 'y'    : [ ':Codi'                           , 'enable' ],
	\ 'n'    : [ ':Codi!'                          , 'disable' ],
	\ }

" Floaterm mappings
let g:which_key_map.t = {
	\ 'name' : '+terminal',
	\ ';'    : [ ':FloatermNew'                    , 'New Terminal' ],
	\ 't'    : [ ':FloatermToggle'                 , 'Toggle Terminal' ],
	\ 'g'    : [ ':FloatermNew lazygit'            , 'git' ],
	\ 'd'    : [ ':FloatermNew lazydocker'         , 'docker' ],
	\ 'p'    : [ ':FloatermNew python3'            , 'python' ],
	\ 'n'    : [ ':FloatermNew node'               , 'node' ],
	\ 'N'    : [ ':FloatermNew nnn'                , 'nnn' ],
	\ }
" TODO: create mappings for quick single file compilation 'c' based on file type


" Splits
" let g:which_key_map['t'] = [ ':Telescope' ]

call which_key#register(' ', 'g:which_key_map')