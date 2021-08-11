
-- https://github.com/rockerBOO/awesome-neovim --
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules --
-- TODO: lazy loading
-- TODO: move treesitter to top
-- TODO: linter (ALE?) - https://github.com/mfussenegger/nvim-lint - coc? efm?
-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- TODO: compiler
-- TODO: set up galaxy line - I/N/V/VL/t mode as single symbol
-- NOTE: Python indent issue (set indentexpr=)
-- NOTE: reorder packer? compile error if package not installed yet
-- https://www.reddit.com/r/neovim/comments/khk335/lua_configuration_global_vim_is_undefined/
-- plugin for shift click to highlight multiple
-- snippets
-- TODO: file type formatting and linter
-- TODO: auto lspinstall for file types without language server - may also fail without sudo
-- NOTE: lsp not working atm


-- https://github.com/wbthomason/packer.nvim --
-- NOTE: config function is run after plugin loaded

-- Autoinstall packer
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim "..install_path)
end

-- vim.cmd [[ packadd packer.nvim ]]
-- vim.cmd([[ autocmd BufWritePost plugins.lua source <afile> | PackerCompile ]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	-----------------------------------------------------------
	-- General Utilities
	-----------------------------------------------------------

	-- Terminal
	use {
    "akinsho/nvim-toggleterm.lua",
    config = require("plugins.toggleterm"),
  }

	-- Fuzzy finder
	use {
  	"nvim-telescope/telescope.nvim",
  	requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		}
	}

		-- Tree file explorer
		-- https://github.com/kevinhwang91/rnvimr
		-- https://github.com/kyazdani42/nvim-tree.lua


	-- Git signs
	use {
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			require("gitsigns").setup()
		end,
	}

	-- Project scope
	-- TODO: check out https://github.com/ahmedkhalf/lsp-rooter.nvim
	-- and its support for non-LSP projects?
	use "airblade/vim-rooter"

  -- Debugger
  use "mfussenegger/nvim-dap"

    -- Spell checker
	use {
		"lewis6991/spellsitter.nvim",
		config = function()
			require('spellsitter').setup {
				hl = "SpellBad",
				captures = {}, -- default: { "comment" }
			}
		end
}

		-- Underline word
		-- NOTE: interferes with highlight search
		use "xiyaowong/nvim-cursorword"

		-- package.json dependency manager
		use {
				"vuki656/package-info.nvim",
				config = function()
					require('package-info').setup()
				end
		}

		-- Smooth scrolling: check out https://github.com/karb94/neoscroll.nvim

		-- Which key
		-- TODO: check out https://github.com/AckslD/nvim-whichkey-setup.lua
		-- TODO: check out https://github.com/folke/which-key.nvim

		-- TODO list (put on dashboard) - neorg or md? - vimwiki?
		-- use { 
    -- "vhyrro/neorg",
    -- config = function()
        -- require('neorg').setup {
            -- -- Tell Neorg what modules to load
            -- load = {
                -- ["core.defaults"] = {}, -- Load all the default modules
                -- ["core.norg.concealer"] = {}, -- Allows for use of icons
                -- ["core.norg.dirman"] = { -- Manage your directories with Neorg
                    -- config = {
                        -- workspaces = {
                            -- my_workspace = "~/neorg"
                        -- }
                    -- }
                -- }
            -- },
        -- }
    -- end,
    -- requires = "nvim-lua/plenary.nvim"
-- }


	-----------------------------------------------------------
	-- Coding Utilities
	-----------------------------------------------------------

	-- Commenting
	use "tpope/vim-commentary"
	

	-- Auto closing pairs
	use "raimondi/delimitMate"
	-- TODO: try https://github.com/windwp/nvim-autopairs#dont-add-pairs-if-the-next-char-is-alphanumeric
	-- Coloured pairs

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
    event = "VimEnter", -- change to buf enter?
		config = require("lsp.lspinstall"),
  }

	-- LSP saga
	use "glepnir/lspsaga.nvim"

	-- Symbols
	use "simrat39/symbols-outline.nvim"

	-- Indenting
	-- use "sheerun/vim-polyglot"

	-- Syntax highlighting
  -- TODO: install parsers for new file types
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
          enable = true,
					additional_vim_regex_highlighting = false,
        },
        indent = {
          indent = false,
        },
      }
    end
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
    -- your statusline
    config = function()
      require "plugins.galaxyline"
    end,
    -- some optional icons
    -- requires = {"kyazdani42/nvim-web-devicons", opt = true}
	}

  -- Tabline
  use {
    'romgrk/barbar.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require "plugins.barbar"
    end,
  }


	-- Startup screen
	use "glepnir/dashboard-nvim"
	-- TODO: see if this integrates https://github.com/rmagatti/auto-session

    -- Indent lines
    use {
			"lukas-reineke/indent-blankline.nvim",
			requires = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("indent_blankline").setup {
					char = "▏",
					show_current_context = true,
					-- exclude vim which key
					filetype_exclude = {
						"dashboard",
						"terminal",
						"packer",
						"help",
					},
				}
			end,
		}

	-- CSS colours
	use "norcalli/nvim-colorizer.lua"

	-- Minimap
	-- use "wfxr/minimap.vim"


end)

