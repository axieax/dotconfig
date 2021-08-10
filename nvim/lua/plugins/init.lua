-- https://github.com/rockerBOO/awesome-neovim --
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules --
-- TODO: lazy loading
-- TODO: move treesitter to top
-- TODO: linter (ALE?) - https://github.com/mfussenegger/nvim-lint - coc? efm?
-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- TODO: compiler
-- TODO: set up galaxy line - I/N/V/VL mode as single symbol
-- NOTE: Python indent issue (set indentexpr=)
-- NOTE: reorder packer? compile error if package not installed yet


-- https://github.com/wbthomason/packer.nvim --

-- Autoinstall packer
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim "..install_path)
end

-- vim.cmd [[ packadd packer.nvim ]]
-- vim.cmd([[ autocmd BufWritePost plugins.lua source <afile> | PackerCompile ]])

return require("packer").startup(
function()
	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	-----------------------------------------------------------
	-- General Utilities
	-----------------------------------------------------------

	-- Floating terminal
	-- TODO: check out https://github.com/akinsho/nvim-toggleterm.lua
	use {
    "voldikss/vim-floaterm",
    config = function()
      require("plugins.floaterm")
    end
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
	use "b3nj5m1n/kommentary"

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
    config = function()
      local nvim_lsp = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

      end

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end
    end
  }

  -- LSP install
  use {
    "kabouzeid/nvim-lspinstall",
    event = "VimEnter",
    config = function()
      local function setup_servers()
        require'lspinstall'.setup()
        local servers = require'lspinstall'.installed_servers()
        for _, server in pairs(servers) do
          require'lspconfig'[server].setup{}
        end
      end

      setup_servers()

      -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
      require'lspinstall'.post_install_hook = function ()
        setup_servers() -- reload installed servers
        vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
      end
    end
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
          enable = true,              -- false will disable the whole extension
        },
        indent = {
          indent = true,
        },
      }
    end
	}

	-- Auto completion
	use {
    "hrsh7th/nvim-compe",
    config = function()
      require("plugins.compe")
    end
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
	-- TODO: customise this - custom background highlight or context indent highlighted
    use "lukas-reineke/indent-blankline.nvim"

	-- CSS colours
	use "norcalli/nvim-colorizer.lua"

	-- Minimap
	-- use "wfxr/minimap.vim"


end)

