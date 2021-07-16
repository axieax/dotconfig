" Plugins
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/themes/airline.vim

set mouse=a

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

" Hybrid relative numbers for normal mode, absolute for insert
set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey


