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
