--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
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
-- Focus.nvim (https://github.com/beauwilliams/focus.nvim)
-- tpope vim-repeat (https://github.com/tpope/vim-repeat)
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
-- distant nvim / remote ssh
--]]

--[[ Notes
-- Python indent issue (set indentexpr=)
-- More efficient to packer install devicons instead?
-- Formatter.nvim prettier doesn't pick up .prettierrc -> use null-ls instead? (has builtins and integrates with lsp)
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
  -- use("Pocco81/DAPInstall.nvim")

  -- Debugger virtual text
  use("theHamsta/nvim-dap-virtual-text")

  -- Python debugger
  use("mfussenegger/nvim-dap-python")

  -- Java debugger
  use("mfussenegger/nvim-jdtls")

  -- Underline word
  -- NOTE: interferes with highlight search
  use("xiyaowong/nvim-cursorword")

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
    config = function()
      vim.g.firenvim_config = {
        localSettings = {
          [".*"] = {
            takeover = "never", -- Autostart
            sync = "change", -- Autosave
            cmdline = "neovim",
          },
        },
      }
      -- Github buffers are Markdown
      vim.cmd("au BufEnter github.com_*.txt set filetype=markdown")
      -- Set up nerd fonts
      -- vim.cmd([[
      -- function! g:IsFirenvimActive(event) abort
      -- if !exists('*nvim_get_chan_info')
      -- return 0
      -- endif
      -- let l:ui = nvim_get_chan_info(a:event.chan)
      -- return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') && l:ui.client.name =~? 'Firenvim'
      -- endfunction

      -- function! OnUIEnter(event) abort
      -- if g:IsFirenvimActive(a:event)
      -- " set laststatus=0
      -- set guifont=Symbols\ Nerd\ Font
      -- endif
      -- endfunction
      -- autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
      -- ]])
    end,
  })

  -- Align lines by character
  use({
    "godlygeek/tabular",
    config = function()
      -- NOTE: Prettier removes this automatic alignment
      local map = require("utils").map
      map({ "i", "|", "|<esc>:lua require('plugins.tabular')()<CR>a" })
    end,
  })

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
    config = function()
      require("lsp").pre_install()
      require("lsp.install")()
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
