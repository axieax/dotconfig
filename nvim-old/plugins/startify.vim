" Startify
let g:startify_session_dir = '~/.config/nvim/sessions'
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

" Custom header

" let s:axieax_1 = [
" 	\ '      __    _  _  ____  ____    __    _  _ ',
" 	\ '     /__\  ( \/ )(_  _)( ___)  /__\  ( \/ )',
" 	\ '    /(__)\  )  (  _)(_  )__)  /(__)\  )  ( ',
" 	\ '   (__)(__)(_/\_)(____)(____)(__)(__)(_/\_)',
" 	\ '   ',
" 	\ '   > Press [s] to restore your last session',
" 	\ ]

let s:axieax_2 = [
	\ '      _____  ____  ___.______________   _____  ____  ___',
	\ '     /  _  \ \   \/  /|   \_   _____/  /  _  \ \   \/  /',
	\ '    /  /_\  \ \     / |   ||    __)_  /  /_\  \ \     / ',
	\ '   /    |    \/     \ |   ||        \/    |    \/     \ ',
	\ '   \____|__  /___/\  \|___/_______  /\____|__  /___/\  \',
	\ '           \/      \_/            \/         \/      \_/',
	\ '   ',
	\ '       > Press [s] to restore your last session <     ',
	\ ]

let g:startify_custom_header = s:axieax_2

