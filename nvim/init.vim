set mouse=a

set termguicolors
syntax on
set number
set ruler
set tabstop=4
set autoindent
set showmatch

set hlsearch
set incsearch
set ignorecase
set smartcase

set cursorline
set cursorbind
set scrollbind
set splitbelow splitright

" Hybrid relative numbers for normal mode, absolute for insert
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey


" buffer edit
set hidden
nmap <TAB> :bnext<CR>
nmap <S-TAB> :bprevious<CR>

" yank line
nnoremap Y y$

command! R :so $MYVIMRC

" WSL clipboard (https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl)

" Plugins
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/themes/airline.vim

