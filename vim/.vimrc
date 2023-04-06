let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'machakann/vim-highlightedyank'

" Plug 'terryma/vim-multiple-cursors'
" Plug 'mg979/vim-visual-multi'
" Plug 'junegunn/fzf.vim'
" Plug 'romainl/vim-cool'
call plug#end()

set number relativenumber
set ignorecase smartcase
set incsearch
set visualbell
set hlsearch
set splitbelow
set splitright

command W w

function! PasteReplace(type)
  execute "normal! `[v`]p"
endfunction
nnoremap <silent> \r <Esc>:set opfunc=PasteReplace<CR>g@

nnoremap <Space>c :echo expand("%")<CR>
nnoremap <Space>C :pwd<CR>
nnoremap <Space>w :update<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>
nnoremap <A-w> :bdelete<CR>
nnoremap <Space>v ggVG
nnoremap <Space>V ggVG"+y
nnoremap gQ ggVGgq

nnoremap Y y$
nnoremap \y "+y
vnoremap \y "+y
nnoremap \+ <Cmd>let @+=@"<CR>
nnoremap \p "0p
vnoremap \p "0p
inoremap <A-t> <C-v><Tab>
vnoremap < <gv
vnoremap > >gv
nnoremap n nzz
nnoremap N Nzz
nnoremap \c "_c
nnoremap \C "_C
nnoremap <C-l> :noh<CR>
nnoremap <A-j> :m +1<CR>
nnoremap <A-k> :m -2<CR>
inoremap jk <Esc>
inoremap kj <Esc>

nnoremap ; :NERDTreeToggle<CR>
