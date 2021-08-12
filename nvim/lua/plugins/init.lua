-- https://github.com/rockerBOO/awesome-neovim --
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules --
-- TODO: lazy loading
-- TODO: move treesitter to top
-- TODO: linter (ALE?) - https://github.com/mfussenegger/nvim-lint - coc? efm?
-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- TODO: compiler, quick code runner?
-- NOTE: Python indent issue (set indentexpr=)
-- plugin for shift click to highlight multiple?
-- snippets
-- TODO: file type formatting and linter (prettier)
-- TODO: auto lspinstall for file types without language server - may also fail without sudo
-- TODO: faded unused variables/imports
-- TODO: gradual undo
-- TODO: automatic backups?
-- TODO: js LSP
-- TODO: emmet, autoclose html
-- TODO: code runner (Codi, https://github.com/dccsillag/magma-nvim)
-- TODO: Markdown HTML treesitter


-- https://github.com/wbthomason/packer.nvim --
-- NOTE: config function is run after plugin loaded

-- Autoinstall packer
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim "..install_path)
end

-- Automatically PackerCompile with changes
vim.cmd([[ autocmd BufWritePost plugins.lua source <afile> | PackerCompile ]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	-----------------------
	-- General Utilities --
	-----------------------

	-- Floating terminal
	use {
		"voldikss/vim-floaterm",
		config = require("plugins.floaterm"),
	}

	-- Fuzzy finder
	use {
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim",
	}

	-- Tree file explorer
	-- https://github.com/kevinhwang91/rnvimr
	-- https://github.com/kyazdani42/nvim-tree.lua

	-- Git signs
	use {
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	}

	-- Project scope
	-- TODO: check out https://github.com/ahmedkhalf/lsp-rooter.nvim
	-- and its support for non-LSP projects?
	-- https://github.com/ahmedkhalf/project.nvim
	use "airblade/vim-rooter"

	-- Debugger
	use "mfussenegger/nvim-dap"

	-- Underline word
	-- NOTE: interferes with highlight search
	use "xiyaowong/nvim-cursorword"

	-- package.json dependency manager
	-- TODO: can it check vulnerabilities?
	use {
		"vuki656/package-info.nvim",
		ft = { "json" },
		config = function()
			require('package-info').setup()
		end,
	}

	-- Which key
	use {
		"folke/which-key.nvim",
		config = require("plugins.whichkey"),
	}

	-- TODO list (put on dashboard) - neorg vs vimwiki?
	-- Get Treesitter parser

	-----------------------------------------------------------
	-- Coding Utilities
	-----------------------------------------------------------

	-- Commenting
	use "tpope/vim-commentary"

	-- Auto closing pairs
	use "raimondi/delimitMate"
	-- TODO: try https://github.com/windwp/nvim-autopairs#dont-add-pairs-if-the-next-char-is-alphanumeric


	-- Coloured pairs
	use {
		"p00f/nvim-ts-rainbow",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require'nvim-treesitter.configs'.setup {
				rainbow = {
					enable = true,
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags
					max_file_lines = 1000,
				}
			}
		end,
	}

	-- Surround with pairs
	use "tpope/vim-surround"

	-- Multiple cursors
	use "mg979/vim-visual-multi"

	-- Interactive scratchpad with virtual text
	-- TODO: check out https://github.com/michaelb/sniprun
	-- use "metakirby5/codi.vim"

	-- Search highlights
	use "romainl/vim-cool"

	-- LSP config
	use {
		"neovim/nvim-lspconfig",
		config = require("lsp.lspconfig"),
	}

	-- LSP install
	use {
		"kabouzeid/nvim-lspinstall",
		config = function()
			require("lsp").pre_install()
			require("lsp.lspinstall")()
		end,
		after = "nvim-lspconfig",
	}

	-- LSP saga
	use {
		"glepnir/lspsaga.nvim",
		config = require("lsp.lspsaga"),
	}

	-- Symbols
	use "simrat39/symbols-outline.nvim"

	-- Syntax highlighting
	-- TODO: install parsers for new file types
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = require("plugins.treesitter"),
	}

	-- Auto completion
	use {
		"hrsh7th/nvim-compe",
		config = require("lsp.compe"),
	}

	-- Snippets
	-- TODO: check out https://github.com/L3MON4D3/LuaSnip
	-- TODO: check out https://github.com/rafamadriz/friendly-snippets

	-- Function signature
	use "ray-x/lsp_signature.nvim"

	-- Autoclose and autorename html tag
	-- TODO: check out https://github.com/windwp/nvim-ts-autotag
	-- ft = { jsx, tsx, html, php, md } ?

	-- Formatter
	-- TODO: check out https://github.com/lukas-reineke/format.nvim


	-----------------------------------------------------------
	-- Customisations
	-----------------------------------------------------------

	-- Theme
	use {
		"navarasu/onedark.nvim",
		config = function()
			-- vim.g.onedark_transparent_background = true
			require("onedark").setup()
		end,
	}

	-- Statusline
	use {
		"glepnir/galaxyline.nvim",
		branch = "main",
		requires = "kyazdani42/nvim-web-devicons",
		config = require("plugins.galaxyline"),
	}

	-- Tabline
	use {
		"romgrk/barbar.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = require("plugins.barbar"),
	}

	-- Startup screen
	-- TODO: see if this integrates https://github.com/rmagatti/auto-session
	use {
		"glepnir/dashboard-nvim",
		config = require("plugins.dashboard"),
	}

	-- Indent blank lines
	use {
		"lukas-reineke/indent-blankline.nvim",
		requires = "nvim-treesitter/nvim-treesitter",
		config = require("plugins.indentline"),
	}

	-- CSS colours
	-- NOTE: doesn't highlight lower case names
	use {
		"norcalli/nvim-colorizer.lua",
		config = function()
			require'colorizer'.setup()
		end,
	}

	-- Minimap
	-- use "wfxr/minimap.vim"

end)

