" General {{{

set mouse=a
set tabstop=4
set autoindent
set splitbelow splitright

set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

" Hybrid relative numbers for normal mode, absolute for insert
set number
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" }}}


" Customisations {{{

syntax on
set ruler

" before or after theme?
set cursorline
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" }}}
