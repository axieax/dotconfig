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

" Which key mappings
let g:which_key_map =  {}

" Startify mappings
let g:which_key_map['s'] = [ ':Startify'          , 'start' ]

" coc mappings
let g:which_key_map.c = {
	\ 'name' : '+coc',
	\ 'i'    : [ ':CocInstall'                     , 'install extensions' ],
	\ 'e'    : [ ':CocList extensions'             , 'list extensions' ],
	\ 'c'    : [ ':CocList commands'               , 'list commands' ],
	\ 'd'    : [ ':CocList diagnostics'            , 'list diagnostics' ],
	\ 'o'    : [ ':CocList outline'                , 'list outline' ],
	\ 's'    : [ ':CocList -I symbols'             , 'list symbols' ],
	\ }

" Floaterm mappings
let g:which_key_map.t = {
	\ 'name' : '+terminal',
	\ ';'    : [ ':FloatermNew'                    , 'New Terminal' ],
	\ 't'    : [ ':FloatermToggle'                 , 'Toggle Terminal' ],
	\ 'l'    : [ ':CocList floaterm'               , 'List Terminals' ],
	\ '['    : [ ':FloatermPrev'                   , 'Previous Terminal' ],
	\ ']'    : [ ':FloatermNext'                   , 'Next Terminal' ],
	\ 'g'    : [ ':FloatermNew lazygit'            , 'git' ],
	\ 'd'    : [ ':FloatermNew lazydocker'         , 'docker' ],
	\ 'p'    : [ ':FloatermNew python3'            , 'python' ],
	\ 'n'    : [ ':FloatermNew node'               , 'node' ],
	\ 'N'    : [ ':FloatermNew nnn'                , 'nnn' ],
	\ }
" TODO: create mappings for quick single file compilation 'c' based on file type

" Fugitive mappings (most don't work)
" let g:which_key_map.g = {
" 	\ 'name' : '+git',
" 	\ 'a'    : [ ':Git add %'                      , 'add' ],
" 	\ 'c'    : [ ':Git commit'                     , 'commit' ],
" 	\ 'd'    : [ ':Gdiffsplit'                     , 'diff' ],
" 	\ 'b'    : [ ':Git branch'                     , 'branch' ],
" 	\ 'm'    : [ ':Git merge'                      , 'merge' ],
" 	\ 'l'    : [ ':Git log'                        , 'log' ],
" 	\ 's'    : [ ':Git'                            , 'status' ],
" 	\ 'B'    : [ ':GBrowse'                        , 'Browse' ],
" 	\ 'g'    : [ ':Ggrep'                          , 'grep' ],
" 	\ }

let g:which_key_map.g = { 'name': '+git' }

nnoremap <nowait><space>ga :Git add 
let g:which_key_map.g.a = 'add'

nnoremap <nowait><space>gc :Git commit
let g:which_key_map.g.c = 'commit'


" Splits
" let g:which_key_map['t'] = [ ':Telescope' ]


call which_key#register('<space>', 'g:which_key_map')
nnoremap <nowait><silent> <space> :silent WhichKey '<Space>'<CR>
vnoremap <nowait><silent> <space> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" TODO: make space toggle

