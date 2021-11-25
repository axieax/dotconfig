--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
--]]

--[[ TODO
-- PRIORITY: formatter.nvim -> null-ls (with https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils ?)
-- PRIORITY: hop -> lightspeed
-- PRIORITY: orgmode / neorg / vimwiki
-- IMPORTANT: separate which-key bindings
-- IMPORTANT: lsp bindings on_attach
-- TODO: ]n next note / todo
-- TODO: Telescope picker for LSP commands
-- TODO: find another terminal (float/horizontal) plugin, make sure it autoresizes
-- TODO: gradle plugin
-- Update lsp config for installation
-- Use eslint LSP instead of eslint_d
-- and use https://github.com/mjlbach/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L187-L229?
-- Try https://github.com/b3nj5m1n/kommentary?
-- Telescope setup, find_files wrapper if buffer is directory
-- Set up linter? (efm, ale, nvim-lint, coc?)
-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
-- Set up snippets (custom and emmet)
-- Automatic lspinstall and treesitter parsers
-- Add auto packer clean, install, compile under autoinstall packer
-- Focus.nvim (https://github.com/beauwilliams/focus.nvim)
-- Merge conflict resolver (like vscode)
-- Cursor hover lsp hover or line diagnostic?
-- nvim cmp dadbod source
-- nvim cmp tzachar/cmp-fzy-buffer?
-- Telescope colorscheme preview
-- Plugin and config split into separate modules
-- TODO list (put on dashboard) - neorg vs vimwiki vs orgmode.nvim?
-- gitsigns hunk preview
-- TODO: gitlinker visual bindings
-- TODO: wildmode (command completion) prefer copen over Copen (default > user-defined)
-- vim-sandwich (remap s?) or surround.nvim instead of surround.vim
-- Git diff preview https://github.com/sindrets/diffview.nvim
-- TODO-COMMMENTS: go to next TODO-mark e.g. ]b?
-- https://github.com/stevearc/stickybuf.nvim
--]]

--[[ Features/plugins
-- Coverage
-- Faded unused variables/imports?
-- Lazy loading
-- Gradual undo
-- Autosave and swapfiles?
-- Emmet / autoclose HTML
-- Markdown HTML Treesitter highlighting + Autotag support
-- Set up quick compiler
-- Code runner (Codi, https://github.com/dccsillag/magma-nvim)
-- https://github.com/ThePrimeagen/refactoring.nvim
-- Markdown preview - ellisonleao/glow.nvim, iamcco/markdown-preview.nvim
-- Markdown continue list on next line
-- Text object for separate parts of variable name, e.g. helloGoodbye, hello_goodbye
-- Telescope-cheat.nvim
-- mrjones2014/dash.nvim for linux?
-- https://github.com/zim0369/butcher string to array
-- https://github.com/ripxorip/aerojump.nvim
-- orgmode.nvim
-- bufferline.nvim or cokeline.nvim instead of barbar?
-- windline instead of galaxyline (deprecated)
-- nvimtree config migration
-- Calltree (https://github.com/ldelossa/calltree.nvim)
-- Git worktree (https://github.com/ThePrimeagen/git-worktree.nvim)
-- gcc diagnostics? (https://gitlab.com/andrejr/gccdiag)
-- https://github.com/b0o/SchemaStore.nvim for jsonls
-- Markdown code block syntax highlighting
-- TRY: https://github.com/goolord/alpha-nvim instead of dashboard
-- with https://github.com/Shatur/neovim-session-manager
-- https://github.com/lewis6991/impatient.nvim
--]]

--[[ Notes
-- Galaxyline gap background not transparent
-- use null-ls as formatter? (has builtins and integrates with lsp)
-- nvim-cmp treesitter completion source vs buffer source?
-- Opening buffer for file (nvim-tree) replaces barbar buffers
-- Markdown TS Parser (https://github.com/MDeiml/tree-sitter-markdown)
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/872
-- Colorizer disabled on PackerCompile
--]]

-- https://github.com/wbthomason/packer.nvim --

-- Autoinstall packer
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local auto_install = vim.fn.empty(vim.fn.glob(packer_path)) > 0
if auto_install then
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
end

-- Automatically PackerCompile with changes
-- vim.cmd([[ autocmd BufWritePost */dotconfig/nvim/*/*.lua source <afile> | PackerCompile ]])

return require("packer").startup(function(use)
  ---------------------
  -- Setup Utilities --
  ---------------------

  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- Improve startup speed
  -- NOTE: can cache packer_compiled as well
  use({
    "lewis6991/impatient.nvim",
    config = function()
      local impatient = require("impatient")
      impatient.enable_profile()
    end,
  })

  -- Filetype config (faster startup and custom overrides)
  use({
    "nathom/filetype.nvim",
    config = function()
      -- NOTE: needed for versions prior to Neovim-0.6
      vim.g.did_load_filetypes = 1
    end,
  })

  -------------
  -- Theming --
  -------------

  -- ALT: https://github.com/ful1e5/onedark.nvim
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

  use({
    "Mofiqul/dracula.nvim",
    config = function()
      vim.g.dracula_transparent_bg = true
    end,
  })

  use({
    "EdenEast/nightfox.nvim",
    config = function()
      local nightfox = require("nightfox")
      nightfox.setup({
        fox = "duskfox",
        transparent = true,
        alt_nc = true,
      })
      -- nightfox.load()
    end,
  })

  use({
    "bluz71/vim-nightfly-guicolors",
    config = function()
      -- TODO: Telescope border and text highlights
      vim.g.nightflyTransparent = 1
    end,
  })

  use({
    "marko-cerovac/material.nvim",
    config = function()
      vim.g.material_style = "palenight"
      require("material").setup({
        borders = true,
        disable = {
          background = true,
        },
        custom_highlights = {
          IndentBlanklineContextChar = { fg = "#C678DD" },
        },
      })
      vim.cmd([[colorscheme material]])
    end,
  })

  -----------------------
  -- General Utilities --
  -----------------------

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-media-files.nvim" },
      -- { "nvim-telescope/telescope-node-modules.nvim" },
    },
    after = {
      "nvim-neoclip.lua",
      "nvim-notify",
      "aerial.nvim",
    },
    config = require("plugins.telescope").setup,
  })

  -- Search for TODO comments and Trouble pretty list
  use({
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
    config = require("plugins.notes"),
  })

  -- Keybinds
  use({
    "folke/which-key.nvim",
    config = require("plugins.binds").which_key,
  })

  -- Extra mappings (with encoding/decoding as well)
  use("tpope/vim-unimpaired")

  -- "." repeat for some commands
  use("tpope/vim-repeat")

  -- Statusline
  use({
    "glepnir/galaxyline.nvim",
    branch = "main",
    requires = "kyazdani42/nvim-web-devicons",
    after = "onedark.nvim",
    config = require("plugins.galaxyline"),
  })

  -- Tabline
  use({
    "romgrk/barbar.nvim",
    disable = false,
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.barbar"),
  })

  -- ALT: https://github.com/akinsho/nvim-bufferline.lua
  use({
    "akinsho/bufferline.nvim",
    disable = true,
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  })

  -- Floating terminal
  use({
    "voldikss/vim-floaterm",
    config = require("plugins.floaterm"),
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    config = require("plugins.toggleterm").setup,
  })

  -- Startup screen
  -- TODO: see if this integrates https://github.com/rmagatti/auto-session
  use({
    "glepnir/dashboard-nvim",
    config = require("plugins.dashboard"),
  })

  -- Zen mode
  use({
    "folke/zen-mode.nvim",
    opt = true,
    cmd = { "ZenMode" },
    requires = "folke/twilight.nvim",
    config = require("plugins.zen"),
  })

  -- Minimap
  -- INSTALL: yay -S code-minimap
  use("wfxr/minimap.vim")

  -- Undo history
  use({
    "mbbill/undotree",
    config = require("plugins.undo"),
  })

  -- Clipboard manager
  use({
    "AckslD/nvim-neoclip.lua",
    requires = { "tami5/sqlite.lua", module = "sqlite" },
    config = function()
      require("neoclip").setup({
        enable_persistant_history = true,
      })
    end,
  })

  -- Notification
  use({
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        render = "minimal",
        on_open = function(win)
          -- transparent background
          -- vim.api.nvim_win_set_option(win, "winblend", 25)
          -- vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      })
    end,
  })

  -- Better quickfix list
  use({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  })

  -- Stabilise buffers
  use({
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup({
        -- for stabilising quickfix list (trouble.nvim)
        nested = "QuickFixCmdPost,User LspDiagnosticsChanged",
      })
    end,
  })

  -- Open with sudo
  -- use("tpope/vim-eunuch")
  use("lambdalisue/suda.vim")

  -- Remote ssh
  -- Without remote distant server: :DistantLaunch server mode=ssh ssh.user=<username>
  use({
    "chipsenkbeil/distant.nvim",
    config = function()
      require("distant").setup({
        -- Applies Chip's personal settings to every machine you connect to
        --
        -- 1. Ensures that distant servers terminate with no connections
        -- 2. Provides navigation bindings for remote directories
        -- 3. Provides keybinding to jump into a remote file's parent directory
        ["*"] = require("distant.settings").chip_default(),
      })
    end,
  })

  -------------------
  -- File Explorer --
  -------------------

  -- Tree file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.nvimtree"),
  })

  -- nnn file explorer
  use({
    "luukvbaal/nnn.nvim",
    disable = true,
    config = function()
      require("nnn").setup({
        explorer = {
          side = "botright",
        },
      })
    end,
  })

  ------------------
  -- Helper Tools --
  ------------------

  -- Text abbreviation / substitution / coercion
  use("tpope/vim-abolish")

  -- Case conversion
  use({
    "arthurxavierx/vim-caser",
    config = function()
      -- Works with motions, text objects and visual mode as well
      vim.g.caser_prefix = "cR"
    end,
  })

  -- Unit converter
  use("simonefranza/nvim-conv")

  -- Incrementor / decrementor
  use({
    "monaqa/dial.nvim",
    config = require("plugins.dial"),
  })

  ------------------
  -- UI Utilities --
  ------------------

  -- Bracket coloured pairs
  -- TODO: change colourscheme, esp red?
  use({
    "p00f/nvim-ts-rainbow",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Indent context indicator
  use({
    "lukas-reineke/indent-blankline.nvim",
    requires = "nvim-treesitter/nvim-treesitter",
    config = require("plugins.indentline"),
  })

  -- Scope context indicator
  use({
    "code-biscuits/nvim-biscuits",
    requires = "nvim-treesitter/nvim-treesitter",
    config = require("plugins.biscuits"),
  })

  -- Mark indicator
  use({
    "chentau/marks.nvim",
    config = function()
      -- m[ and m] to navigate marks
      require("marks").setup({})
    end,
  })

  -- Underline word under cursor
  use({
    "osyo-manga/vim-brightest",
    config = function()
      -- Highlight group (e.g. BrighestUndercurl)
      vim.g["brightest#highlight"] = { group = "BrightestUnderline" }
    end,
  })

  -- CSS colours
  -- NOTE: doesn't highlight lower case names (#18)
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  })

  -- Search highlights
  use("romainl/vim-cool")

  -- Substitution preview
  use("markonm/traces.vim")

  -- Smooth scroll
  -- TODO: configure animation duration
  use({
    "karb94/neoscroll.nvim",
    disable = true,
    config = function()
      require("neoscroll").setup()
    end,
  })

  ----------------------
  -- Motion Utilities --
  ----------------------

  -- Multiple cursors
  use("mg979/vim-visual-multi")

  -- Easy motion
  -- ALT: https://github.com/ggandor/lightspeed.nvim
  use({
    "phaazon/hop.nvim",
    config = require("plugins.hop"),
  })

  -----------------------------
  -- Project / Git Utilities --
  -----------------------------

  -- Project scope
  -- ALT: https://github.com/ahmedkhalf/project.nvim and its support for non-LSP projects?
  use("airblade/vim-rooter")

  -- Project settings
  use("tpope/vim-sleuth")

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

  -- GitHub issues and pull requests
  use({
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
  })

  -----------------------------------
  -- General Programming Utilities --
  -----------------------------------

  -- Language parser + syntax highlighting
  -- TODO: automatically install parsers for new file types (don't download all)
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = require("plugins.treesitter"),
  })

  -- Treesitter parser info
  use({
    "nvim-treesitter/playground",
    run = ":TSUpdate query",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Treesitter text objects
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "0.5-compat",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Treesitter text subjects
  use({
    "RRethy/nvim-treesitter-textsubjects",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- GitHub Copilot (NOTE: requires neovim 0.6)
  use({
    "github/copilot.vim",
    -- disable = true,
    config = function()
      -- imap <silent><script><expr> <C-L> copilot#Accept()
      local map = require("utils").map
      map({ "i", "<C-a>", "copilot#Accept()", script = true, expr = true, silent = true })
      vim.g.copilot_no_tab_map = true
    end,
  })

  -- Interactive scratchpad with virtual text
  -- ALT: https://github.com/michaelb/sniprun
  use("metakirby5/codi.vim")

  -- Code formatter
  use({
    "mhartington/formatter.nvim",
    config = require("lsp.formatter"),
  })

  -- Align lines by character
  use({
    "godlygeek/tabular",
    config = require("plugins.tabular").setup,
  })

  -- Commenting
  -- ALT: https://github.com/numToStr/Comment.nvim with TS support
  use("tpope/vim-commentary")

  -- Better commentstring (for vim-commentary)
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- Surround with brackets
  use("tpope/vim-surround")

  -- Snippets
  -- TODO: check out https://github.com/L3MON4D3/LuaSnip and Ultisnips

  -- Snippet collection
  use("rafamadriz/friendly-snippets")

  -- Definable snippets
  use("hrsh7th/vim-vsnip")

  -- Docstring generator
  -- ALT: https://github.com/nvim-treesitter/nvim-tree-docs
  use({
    "kkoomen/vim-doge",
    run = ":call doge#install()",
  })

  -- Autoclose and autorename html tag
  use({
    "windwp/nvim-ts-autotag",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- package.json dependency manager
  -- TODO: can it check vulnerabilities?
  use({
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = { "json" },
    config = require("plugins.package"),
  })

  -- Python indenting issues
  use("Vimjas/vim-python-pep8-indent")

  -- Markdown LaTeX paste image
  -- NOTE: requires xclip (X11), wl-clipboard (Wayland) or pngpaste (MacOS)
  use({
    "ekickx/clipboard-image.nvim",
    opt = true,
    cmd = { "PasteImg" },
    config = require("plugins.pasteimage"),
  })

  ---------------------------------
  -- Compilation, Test and Debug --
  ---------------------------------

  -- Make
  use("neomake/neomake")

  -- Compiler (e.g. :Dispatch python3.9 %)
  use("tpope/vim-dispatch")

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
    requires = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = require("lsp.debug"),
  })

  -- Debugger installer
  use("Pocco81/DAPInstall.nvim")

  -------------------
  -- LSP Utilities --
  -------------------

  -- LSP config
  use({
    "neovim/nvim-lspconfig",
    config = require("lsp.config"),
  })

  -- LSP install
  use({
    "williamboman/nvim-lsp-installer",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "stevearc/aerial.nvim",
    },
    config = require("lsp.install").setup,
    after = "nvim-lspconfig",
  })

  -- Rename
  use({
    "filipdutescu/renamer.nvim",
    config = require("lsp.rename").renamer_setup,
  })

  -- Java LSP
  use("mfussenegger/nvim-jdtls")

  -- LSP diagnostics toggle
  use({
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init()
    end,
  })

  -- Symbols outline
  -- use("simrat39/symbols-outline.nvim")
  use({
    "stevearc/aerial.nvim",
    config = function()
      vim.g.aerial = {
        -- close_behavior = "close",
        highlight_on_jump = 200,
        close_on_select = true,
      }
    end,
  })

  -- Code action menu
  use({
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  })

  -- Code action prompt
  use({
    "kosayoda/nvim-lightbulb",
    config = function()
      vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'plugins.lightbulb'()]])
    end,
  })

  -- Completion menu
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "windwp/nvim-autopairs" },
      { "lukas-reineke/cmp-under-comparator" },
      { "onsails/lspkind-nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-calc" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-cmdline" },
      { "f3fora/cmp-spell" },
      { "kdheepak/cmp-latex-symbols", opt = true },
      { "David-Kunz/cmp-npm", requires = "nvim-lua/plenary.nvim" },
      { "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" },
      -- { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
      -- "ray-x/cmp-treesitter",
      -- "quangnguyen30192/cmp-nvim-tags",
      -- "tpope/vim-dadbod",
      -- "kristijanhusak/vim-dadbod-ui",
      -- "kristijanhusak/vim-dadbod-completion",
      -- "tzachar/cmp-fzy-buffer",
      -- "tzachar/cmp-fuzzy-path",
    },
    config = require("lsp.cmp"),
  })

  -- Function signature
  use({
    "ray-x/lsp_signature.nvim",
    config = require("lsp.signature"),
  })

  -------------------
  -- Miscellaneous --
  -------------------

  -- Browser integration
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
    config = require("plugins.firenvim"),
  })

  -- Packer auto update + compile
  if auto_install then
    require("packer").sync()
  end
end)
