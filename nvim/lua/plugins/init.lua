--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
--]]

--[[ TODO
-- LSP compe fuzzy strategy
-- Move treesitter, devicons to top?
-- Telescope setup, find_files wrapper if buffer is directory
-- Set up JS LSP - no root dir (or put config in test folder)
-- Set up Dashboard session manager
-- Set up formatter (Prettier, Black), linter (efm, ale, nvim-lint, coc?)
	-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- Set up snippets (emmet)
-- Automatic lspinstall and treesitter parsers
-- Add auto packer clean, install, compile under autoinstall packer
--]]

--[[ Features/plugins
-- Faded unused variables/imports
-- Lazy loading
-- Gradual undo
-- Autosave
-- Hop
-- Emmet / autoclose HTML
-- Markdown HTML treesitter highlighting
-- Set up quick compiler
-- Code runner (Codi, https://github.com/dccsillag/magma-nvim)
-- Use es_lintd for js/ts
-- Minimap preview
-- https://github.com/ThePrimeagen/refactoring.nvim
-- yank list (https://github.com/AckslD/nvim-neoclip.lua)
-- zen mode
--]]

--[[ Notes
-- Python indent issue (set indentexpr=)
-- More efficient to packer install devicons instead?
--]]

-- https://github.com/wbthomason/packer.nvim --

-- Autoinstall packer
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. packer_path)
end

-- Automatically PackerCompile with changes
vim.cmd([[ autocmd BufWritePost plugins.lua source <afile> | PackerCompile ]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -----------------------
  -- General Utilities --
  -----------------------

  -- Floating terminal
  use({
    "voldikss/vim-floaterm",
    config = require("plugins.floaterm"),
  })

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      "nvim-telescope/telescope-dap.nvim",
    },
    config = require("plugins.telescope"),
  })

  -- Tree file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.tree"),
  })

  -- Undo history
  use({
    "mbbill/undotree",
    config = require("plugins.undo"),
  })

  -- Git signs
  use({
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  })

  -- Project scope
  -- TODO: check out https://github.com/ahmedkhalf/project.nvim
  -- and its support for non-LSP projects?
  -- https://github.com/ahmedkhalf/project.nvim
  use("airblade/vim-rooter")

  -- Unit test
  use({
    "rcarriga/vim-ultest",
    requires = "vim-test/vim-test",
    config = require("lsp.test"),
    run = ":UpdateRemotePlugins",
  })

  -- Debugger
  use({
    "rcarriga/nvim-dap-ui",
    requires = "mfussenegger/nvim-dap",
    config = require("lsp.debug"),
  })

  -- Debugger installer
  -- use("Pocco81/DAPInstall.nvim")

  -- Python debugger
  use("mfussenegger/nvim-dap-python")

  -- Java debugger
  use("mfussenegger/nvim-jdtls")
  -- use("microsoft/java-debug")

  -- Underline word
  -- NOTE: interferes with highlight search
  use("xiyaowong/nvim-cursorword")

  -- package.json dependency manager
  -- TODO: can it check vulnerabilities?
  use({
    "vuki656/package-info.nvim",
    ft = { "json" },
    config = function()
      require("package-info").setup()
    end,
  })

  -- Which key
  use({
    "folke/which-key.nvim",
    config = require("plugins.whichkey"),
  })

  -- TODO list (put on dashboard) - neorg vs vimwiki?
  -- Get Treesitter parser

  -----------------------------------------------------------
  -- Coding Utilities
  -----------------------------------------------------------

  -- Commenting
  use("tpope/vim-commentary")

  -- Auto closing pairs
  use("raimondi/delimitMate")
  -- TODO: try https://github.com/windwp/nvim-autopairs#dont-add-pairs-if-the-next-char-is-alphanumeric
  -- NOTE: remember to update compe <CR> map

  -- Surround with pairs
  use("tpope/vim-surround")

  -- Multiple cursors
  use("mg979/vim-visual-multi")

  -- Interactive scratchpad with virtual text
  -- TODO: check out https://github.com/michaelb/sniprun
  -- use "metakirby5/codi.vim"

  -- Search highlights
  use("romainl/vim-cool")

  -- LSP config
  use({
    "neovim/nvim-lspconfig",
    config = require("lsp.lspconfig"),
  })

  -- LSP install
  use({
    "kabouzeid/nvim-lspinstall",
    after = "nvim-lspconfig",
    config = function()
      require("lsp").pre_install()
      require("lsp.lspinstall")()
    end,
  })

  -- Symbols
  use("simrat39/symbols-outline.nvim")

  -- Syntax highlighting
  -- TODO: install parsers for new file types (don't download all)
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = require("plugins.treesitter"),
  })
  use({
    "nvim-treesitter/playground",
    requires = "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate query",
  })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "0.5-compat",
  })

  -- Auto completion (replace with hrsh7th/nvim-cmp)
  use({
    "hrsh7th/nvim-compe",
    config = require("lsp.compe"),
  })

  -- Snippets
  -- TODO: check out https://github.com/L3MON4D3/LuaSnip
  -- Snippet collection
  use("rafamadriz/friendly-snippets")
  -- Definable snippets
  use("hrsh7th/vim-vsnip")

  -- Function signature
  use("ray-x/lsp_signature.nvim")

  -- Autoclose and autorename html tag
  use({
    "windwp/nvim-ts-autotag",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Formatter
  use({
    "mhartington/formatter.nvim",
    config = require("lsp.formatter"),
  })

  -- Make
  use("neomake/neomake")

  -----------------------------------------------------------
  -- Customisations
  -----------------------------------------------------------

  -- Theme
  use({
    "navarasu/onedark.nvim",
    config = function()
      vim.g.onedark_transparent_background = true
      require("onedark").setup()
    end,
  })

  -- Statusline
  use({
    "glepnir/galaxyline.nvim",
    branch = "main",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.galaxyline"),
  })

  -- Tabline
  -- TODO: check out https://github.com/akinsho/nvim-bufferline.lua
  use({
    "romgrk/barbar.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.barbar"),
  })

  -- Startup screen
  -- TODO: see if this integrates https://github.com/rmagatti/auto-session
  use({
    "glepnir/dashboard-nvim",
    config = require("plugins.dashboard"),
  })

  -- Indent blank lines
  use({
    "lukas-reineke/indent-blankline.nvim",
    requires = "nvim-treesitter/nvim-treesitter",
    config = require("plugins.indentline"),
  })

  -- Coloured pairs
  -- TODO: change colourscheme, esp red
  use({
    "p00f/nvim-ts-rainbow",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags
          max_file_lines = 1000,
        },
      })
    end,
  })

  -- CSS colours
  -- NOTE: doesn't highlight lower case names
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  })

  -- use 'kyazdani42/nvim-web-devicons'
end)
