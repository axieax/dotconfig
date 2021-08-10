let g:mapleader = ','

" buffer edit
set hidden
nmap <TAB> :bnext<CR>
nmap <S-TAB> :bprevious<CR>

" yank line
nnoremap Y y$

" source init.vim
command! R :so $MYVIMRC
