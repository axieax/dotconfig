--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
--]]

--[[ TODO
-- Try https://github.com/b3nj5m1n/kommentary?
-- set up nvim-lightbulb with weilbith/nvim-code-action-menu to get CA diff
-- Telescope setup, find_files wrapper if buffer is directory
-- Set up linter? (efm, ale, nvim-lint, coc?)
	-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- Set up snippets (custom and emmet)
-- Automatic lspinstall and treesitter parsers
-- Add auto packer clean, install, compile under autoinstall packer
-- Focus.nvim (https://github.com/beauwilliams/focus.nvim)
-- Merge conflict resolver (like vscode)
-- CursorHold lsp hover or line diagnostic?
--]]

--[[ Features/plugins
-- Faded unused variables/imports?
-- Lazy loading
-- Gradual undo
-- Autosave and swapfiles?
-- Emmet / autoclose HTML
-- Markdown HTML Treesitter highlighting + Autotag support
-- Set up quick compiler
-- Code runner (Codi, https://github.com/dccsillag/magma-nvim)
-- Minimap preview
-- https://github.com/ThePrimeagen/refactoring.nvim
-- yank list (https://github.com/AckslD/nvim-neoclip.lua)
-- distant nvim / remote ssh
-- Markdown preview - ellisonleao/glow.nvim
--]]

--[[ Notes
-- Prettier config not picked up
-- Galaxyline gap background not transparent
-- Formatter.nvim prettier doesn't pick up .prettierrc -> use null-ls instead? (has builtins and integrates with lsp)
-- nvim-cmp treesitter completion source vs buffer source?
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
    config = require("plugins.telescope").setup,
  })

  -- Tree file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.nvimtree"),
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
    config = require("plugins.gitsigns"),
  })

  -- Git repo link
  use({
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = require("plugins.gitlinker"),
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
    config = require("lsp.test").setup,
    run = ":UpdateRemotePlugins",
  })

  -- Debugger
  use({
    "rcarriga/nvim-dap-ui",
    requires = "mfussenegger/nvim-dap",
    config = require("lsp.debug"),
  })

  -- Debugger installer
  use("Pocco81/DAPInstall.nvim")

  -- Debugger virtual text
  use("theHamsta/nvim-dap-virtual-text")

  -- Python debugger
  use("mfussenegger/nvim-dap-python")

  -- Java debugger
  use("mfussenegger/nvim-jdtls")

  -- Underline word
  use({
    "yamatsum/nvim-cursorline",
    -- disable = true,
    config = function()
      vim.g.cursorline_timeout = 0 -- time before cursorline appears
    end,
  })

  -- package.json dependency manager
  -- TODO: can it check vulnerabilities?
  use({
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = require("plugins.package"),
  })

  -- Which key
  use({
    "folke/which-key.nvim",
    config = require("plugins.whichkey"),
  })

  -- Easy motion
  use({
    "phaazon/hop.nvim",
    as = "hop",
    config = require("plugins.hop"),
  })

  -- TODO list (put on dashboard) - neorg vs vimwiki?
  -- Get Treesitter parser

  -- Browser integration
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("plugins.firenvim"),
  })

  -- Align lines by character
  use({
    "godlygeek/tabular",
    config = require("plugins.tabular").setup,
  })

  -- Search for TODO comments and Trouble pretty list
  use({
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
    config = require("plugins.notes"),
  })

  -----------------------------------------------------------
  -- Coding Utilities
  -----------------------------------------------------------

  -- Commenting
  use("tpope/vim-commentary")

  -- Auto closing pairs
  use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = require("plugins.pairs"),
  })

  -- Surround with pairs
  use("tpope/vim-surround")

  -- "." repeat for some commands
  use("tpope/vim-repeat")

  -- Multiple cursors
  use("mg979/vim-visual-multi")

  -- Interactive scratchpad with virtual text
  -- TODO: check out https://github.com/michaelb/sniprun
  use("metakirby5/codi.vim")

  -- Search highlights
  use("romainl/vim-cool")

  -- LSP config
  use({
    "neovim/nvim-lspconfig",
    config = require("lsp.config"),
  })

  -- LSP install
  use({
    "kabouzeid/nvim-lspinstall",
    after = "nvim-lspconfig",
    config = require("lsp.install"),
  })

  -- Symbols
  use("simrat39/symbols-outline.nvim")

  -- Code action menu
  use({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  })

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

  -- Python indenting issues
  use("Vimjas/vim-python-pep8-indent")

  -- Auto completion (replace with hrsh7th/nvim-cmp)
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "f3fora/cmp-spell",
      "kdheepak/cmp-latex-symbols",
      { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
      -- "ray-x/cmp-treesitter",
      -- "quangnguyen30192/cmp-nvim-tags",
      -- "tpope/vim-dadbod",
      -- "kristijanhusak/vim-dadbod-ui",
      -- "kristijanhusak/vim-dadbod-completion",
    },
    config = require("lsp.cmp"),
  })

  -- Snippets
  -- TODO: check out https://github.com/L3MON4D3/LuaSnip
  -- Ultisnips
  -- Snippet collection
  use("rafamadriz/friendly-snippets")
  -- Definable snippets
  use("hrsh7th/vim-vsnip")

  -- Function signature
  use({
    "ray-x/lsp_signature.nvim",
    config = require("lsp.signature"),
  })

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

  -- Docstring generator
  use({
    "kkoomen/vim-doge",
    run = ":call doge#install()",
  })

  -- Incrementor/decrementor
  use("monaqa/dial.nvim")

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
  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.g.tokyonight_transparent = true
      vim.g.tokyonight_transparent_sidebar = true
    end,
  })

  -- Statusline
  use({
    "glepnir/galaxyline.nvim",
    branch = "main",
    requires = "kyazdani42/nvim-web-devicons",
    after = "onedark.nvim",
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

  -- Zen mode
  use({
    "folke/zen-mode.nvim",
    requires = "folke/twilight.nvim",
    config = require("plugins.zen"),
  })

  -- Substitution preview
  use("markonm/traces.vim")

  -- use 'kyazdani42/nvim-web-devicons'
end)
