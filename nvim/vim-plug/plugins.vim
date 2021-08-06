" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	"autocmd VimEnter * PlugInstall
	"autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" Theme
Plug 'joshdick/onedark.vim'
" Startify
Plug 'mhinz/vim-startify'
Plug 'scrooloose/NERDTree'
" TODO: get NERD fonts / dev icons
" Floaterm
Plug 'voldikss/vim-floaterm'
" Which Key
Plug 'liuchengxu/vim-which-key'
" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Better Syntax Support
Plug 'sheerun/vim-polyglot'
" Neovim Tree Sitter
" Plug 'nvim-treesitter/nvim-treesitter'
" Auto Pairs
Plug 'jiangmiao/auto-pairs'
" Add brackets/quote around
Plug 'tpope/vim-surround'
" Comment/uncomment: gcc for line, gc for selected
Plug 'tpope/vim-commentary'
" Multiple cursors CTRL-N
Plug 'mg979/vim-visual-multi'
" Interactive Scratchpad
Plug 'metakirby5/codi.vim'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Telescope
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" Need something for interpreter warnings
" Search Highlights
Plug 'romainl/vim-cool'

call plug#end()

" theme
colorscheme onedark

" coc config
let g:coc_global_extensions = [
	\ 'coc-snippets',
	\ 'coc-prettier',
	\ 'coc-highlight',
	\ 'coc-pyright',
	\ 'coc-clangd',
	\ 'coc-emmet',
	\ 'coc-css',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-tsserver',
	\ 'coc-r-lsp',
	\ ]
" \ 'coc-pairs',

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Emmet tab
" https://youtu.be/KPsvfhACnpc
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <silent> gp :Prettier <cr>


" Telescope
" Find files using Telescope command-line sugar.
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Startify
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_enable_special = 0
autocmd VimLeave * :SSave! recent

let g:startify_lists = [
	\ { 'type': 'files',     'header': ['   Files']            },
	\ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
	\ { 'type': 'sessions',  'header': ['   Sessions']       },
	\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
	\ { 'type': 'commands',  'header': ['   Commands'] },
	\ ]

let g:startify_commands = [
	\ { 's': 'SLoad! recent' },
	\ ]

let g:startify_bookmarks = [
	\ { 'c': '~/.config/nvim' },
	\ { 'd': '~/dev' },
	\ { 'z': '~/.zshrc' },
	\ '~/test',
	\ ]


" Floaterm
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'

let g:loaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1


" Map leader to which_key
nnoremap <silent> <space> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <space> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = ':'
" set timeoutlen=100

let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
	\| autocmd  BufLeave <buffer> set laststatus=2 noshowmode ruler


" Single mappings
let g:which_key_map['s'] = [ ':Startify'          , 'start' ]
" Splits
" let g:which_key_map['t'] = [ ':Telescope' ]

" Codi toggle
let g:which_key_map.c = {
	\ 'name' : '+codi',
	\ 'y'    : [ ':Codi'                           , 'enable' ],
	\ 'n'    : [ ':Codi!'                          , 'disable' ],
	\ }

" Floaterm options
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

call which_key#register(' ', 'g:which_key_map')

