" https://github.com/junegunn/vim-plug

" Install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.config/nvim/autoload/plugged')

" Customisations {{{

	" Onedark theme
	Plug 'joshdick/onedark.vim'

	" Airline
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

" }}}


" General Utilities {{{

	" Startify with NERDTree file explorer
	Plug 'mhinz/vim-startify'
	Plug 'scrooloose/NERDTree'
	" TODO: get NERD fonts / dev icons

	" Floating Terminal
	Plug 'voldikss/vim-floaterm'

	" Which Key
	Plug 'liuchengxu/vim-which-key'

	" File Explorer
	if (has('nvim-0.5.0'))
		" Telescope
		Plug 'nvim-lua/popup.nvim'
		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-telescope/telescope.nvim'
	endif

	" Git
	Plug 'tpope/vim-fugitive'

" }}}


" Coding Utilities {{{

	" Conquer of Completion
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" Syntax Highlighting
	if (has('nvim-0.5.0'))
		" Tree Sitter
		Plug 'nvim-treesitter/nvim-treesitter'
	else
		" Polyglot
		Plug 'sheerun/vim-polyglot'
	endif

	" Comment/uncomment: gcc for line, gc for selected
	Plug 'tpope/vim-commentary'

	" Auto Pairs
	Plug 'jiangmiao/auto-pairs'
	" Surround with Pairs
	Plug 'tpope/vim-surround'

	" Multiple Cursors (ctrl-N, ctrl-arrows)
	Plug 'mg979/vim-visual-multi'

	" Interactive Scratchpad with Virtual Text
	Plug 'metakirby5/codi.vim'

	" Search Highlights
	Plug 'romainl/vim-cool'

" }}}


call plug#end()


" Source plugin settings
source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/startify.vim
source $HOME/.config/nvim/plugins/floaterm.vim
" source $HOME/.config/nvim/plugins/telescope.vim
source $HOME/.config/nvim/plugins/whichkey.vim
