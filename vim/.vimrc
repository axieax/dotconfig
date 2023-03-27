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

" Plug 'romainl/vim-cool'
" Plug 'justinmk/vim-sneak'
" Plug 'andymass/vim-matchup'
call plug#end()

set number relativenumber
set ignorecase smartcase
set incsearch
set visualbell
set hlsearch

nnoremap <Space>w :update<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>
nnoremap <A-w> :bdelete<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap <Space>v ggVG
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-l> :noh<CR>

nnoremap ; :NERDTreeToggle<CR>
