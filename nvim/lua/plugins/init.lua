--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
-- TODO: https://github.com/jose-elias-alvarez/dotfiles/blob/main/config/nvim/lua/plugins/init.lua
-- TODO: https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/lua/numToStr/plugins.lua
-- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/options.lua
--]]

--[[ TODO
-- IDEA: nvim-wrap (prompt for wrapper for selected text), e.g. console.log(...), markdown [](), mapping templates
-- shift-i to edit before, shift-a to edit after (normal mode binds work)
-- basically a substitution using vim.ui.input
-- dot-repeatable
-- vim ui select for template for ft
-- support for text objects instead of selecting visually first
-- PRIORITY: Separate treesitter and telescope extensions, use Packer sequencing (after)
-- IMPORTANT: group which-key bindings
-- IMPORTANT: lsp bindings into on_attach
-- IMPORTANT: util map function use which-key (pcall)
-- IMPORTANT: uncomment adjacent lines
-- IMPORTANT: set up toggleterm
-- TODO: use vim-fugitive instead of gitlinker?
-- TODO: ]n or ]b next note / todo (todo-commments go to next bookmark)
-- TODO: Telescope picker for LSP commands
-- TODO: null-ls on_attach disable formatting
-- TODO: lsp-rename no pre-filled text, transparent window
-- TRY: vim.lsp.codelens.run()
-- Update lsp config for installation
-- and use https://github.com/mjlbach/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L187-L229?
-- Telescope setup, find_files wrapper if buffer is directory
-- Set up snippets (custom and emmet)
-- Automatic lspinstall and treesitter parsers
-- Add auto packer clean, install, compile under autoinstall packer
-- Focus.nvim (https://github.com/beauwilliams/focus.nvim)
-- Merge conflict resolver (like vscode) - fugitive has this
-- Cursor hover lsp hover or line diagnostic?
-- nvim cmp dadbod source
-- nvim cmp tzachar/cmp-fzy-buffer?
-- Plugin and config split into separate modules?
-- TODO: wildmode (command completion) prefer copen over Copen (default > user-defined)
-- vim-sandwich (remap s?) or surround.nvim instead of surround.vim
-- Git diff preview https://github.com/sindrets/diffview.nvim
-- https://github.com/stevearc/stickybuf.nvim
-- Material nvim todo-comment 0.6 highlights
-- TODO: lsp config separate into install, setup, utils
-- https://github.com/Gelio/ubuntu-dotfiles/blob/master/install/neovim/stowed/.config/nvim/lua/lsp/tsserver.lua#L13
--]]

--[[ Features/plugins
-- LSPCommands Telescope interface
-- Terminal (float/horizontal) which autosizes
-- Coverage
-- Gradle
-- Faded unused variables/imports?
-- Lazy loading (event = "BufWinEnter"?) https://youtu.be/JPEx2kI6pfo
-- Emmet support for jsx/tsx
-- Emmet / autoclose HTML
-- Gradual undo
-- Markdown HTML Treesitter highlighting + Autotag support
-- Autosave and swapfiles?
-- Set up quick compiler
-- Code runner (Codi, https://github.com/dccsillag/magma-nvim)
-- Markdown continue list on next line
-- Text object for separate parts of variable name, e.g. helloGoodbye, hello_goodbye
-- Telescope-cheat.nvim
-- mrjones2014/dash.nvim for linux?
-- https://github.com/zim0369/butcher string to array
-- https://github.com/ripxorip/aerojump.nvim
-- bufferline.nvim or cokeline.nvim instead of barbar?
-- windline instead of galaxyline (deprecated)
-- nvimtree config migration
-- Calltree (https://github.com/ldelossa/calltree.nvim)
-- Git worktree (https://github.com/ThePrimeagen/git-worktree.nvim)
-- gcc diagnostics? (https://gitlab.com/andrejr/gccdiag)
-- Markdown code block syntax highlighting
-- with line for startup time (v --startuptime and read tmp file?)
-- something like https://github.com/henriquehbr/nvim-startup.lua?
-- https://github.com/rmagatti/auto-session
-- https://github.com/VonHeikemen/fine-cmdline.nvim
-- Themes: try sonokai and monokai
-- Telescope frecency, smart-history
-- NOTE: rust-tools not setup yet (lsp-installer integration)
-- Rust run/debug code-lens not working
--]]

--[[ Notes / issues
-- Markdown issues - code block cindent, no auto list formatoptions
-- https://www.reddit.com/r/neovim/comments/r8qcxl/nvimcmp_deletes_the_first_word_after_autocomplete/
-- https://github.com/hrsh7th/nvim-cmp/issues/611
-- inccommand split preview-window scroll
-- nvim-cmp treesitter completion source vs buffer source?
-- Opening buffer for file (nvim-tree) replaces barbar buffers
-- Markdown TS Parser (https://github.com/MDeiml/tree-sitter-markdown)
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/872
-- Colorizer disabled on PackerCompile
-- LSP format, autopairs may start to break after a while
-- vim-mundo window maps
-- floats may be closed soon after nvim startup (e.g. Telescope, lazygit)
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

return require("packer").startup({
  function(use)
    ---------------------
    -- Setup Utilities --
    ---------------------

    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Improve and measure startup time
    -- NOTE: can cache packer_compiled as well
    use({
      "lewis6991/impatient.nvim",
      disable = true,
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
      "olimorris/onedarkpro.nvim",
      config = function()
        require("onedarkpro").setup({
          -- extra from https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/colors.lua
          colors = {
            bg_blue = "#73b8f1",
            dark_purple = "#8a3fa0",
          },
          hlgroups = {
            -- TSProperty = { fg = "${gray}" },
            -- TSVariable = { fg = "${fg}" },
          },
          styles = {
            -- functions = "bold,italic",
            -- variables = "italic",
          },
          options = {
            transparency = true,
          },
        })
        -- require("onedarkpro").load()
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
            StatusLine = { bg = "#00000000" },
            -- TODO: cmp item kind highlights
            -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
            -- HLGROUP = { link = "OTHER_GROUP" },
          },
        })
        vim.cmd([[colorscheme material]])
      end,
    })

    -----------------------
    -- General Utilities --
    -----------------------

    -- Keybinds
    use({
      "folke/which-key.nvim",
      config = require("plugins.binds").which_key,
    })

    -- Fuzzy finder
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        -- Extensions
        { "nvim-telescope/telescope-symbols.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-dap.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "ahmedkhalf/project.nvim" },
        -- { "nvim-telescope/telescope-node-modules.nvim" },
        { "mfussenegger/nvim-dap" },
        { "rcarriga/nvim-notify" },
        { "stevearc/aerial.nvim" },
      },
      config = require("plugins.telescope").setup,
    })

    -- Search for TODO comments and Trouble pretty list
    use({
      "folke/todo-comments.nvim",
      requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
      config = require("plugins.notes"),
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
      after = "onedarkpro.nvim",
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
    -- TODO: replace
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
    use({
      "goolord/alpha-nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = require("plugins.start"),
    })

    -- Session manager
    -- ALT: https://github.com/rmagatti/auto-session with https://github.com/rmagatti/session-lens
    use({
      "Shatur/neovim-session-manager",
      after = "telescope.nvim",
      config = function()
        require("session_manager").setup({
          autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        })
        require("telescope").load_extension("sessions")
      end,
    })

    -- Emacs Orgmode
    -- ALT: vimwiki (more for notes/diary), neorg (too different from md)
    -- NOTE: https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md#getting-started-with-orgmode
    use({
      "nvim-orgmode/orgmode",
      requires = {
        "nvim-treesitter/nvim-treesitter",
        "akinsho/org-bullets.nvim",
      },
      config = function()
        require("orgmode").setup({
          org_agenda_file = { "~/wiki/**" },
          mappings = {
            global = {
              org_agenda = "<space>oa",
              org_capture = "<space>oc",
            },
          },
        })
      end,
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
      "simnalamburt/vim-mundo",
      config = require("plugins.undo"),
    })

    -- Clipboard manager
    use({
      "AckslD/nvim-neoclip.lua",
      requires = { "tami5/sqlite.lua", module = "sqlite" },
      after = "telescope.nvim",
      config = function()
        require("neoclip").setup({
          enable_persistant_history = true,
        })
        require("telescope").load_extension("neoclip")
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
            -- https://github.com/rcarriga/nvim-notify/issues/16
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
        -- for stabilising quickfix list (trouble.nvim)
        local nested_autocmd = require("utils").ternary(
          vim.fn.has("nvim-0.6"),
          "QuickFixCmdPost,DiagnosticChanged *",
          "QuickFixCmdPost,User LspDiagnosticsChanged"
        )
        require("stabilize").setup({
          nested = nested_autocmd,
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

    -- vim.ui overrides
    use("stevearc/dressing.nvim")

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
      event = "BufRead",
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

    -- Search virtual text
    use({
      "kevinhwang91/nvim-hlslens",
      config = require("plugins.hlslens").setup,
    })

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

    -- Easy motion / navigation
    use("ggandor/lightspeed.nvim")

    -----------------------------
    -- Project / Git Utilities --
    -----------------------------

    -- Project scope
    use({
      "ahmedkhalf/project.nvim",
      after = "telescope.nvim",
      config = function()
        require("project_nvim").setup()
        require("telescope").load_extension("projects")
      end,
    })

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
    -- TODO: auto disable on startup
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

    -- Align lines by character
    use({
      "godlygeek/tabular",
      config = require("plugins.tabular").setup,
    })

    -- Commenting
    -- NOTE: missing uncomment adjacent (gcgc, gcu)
    -- https://github.com/numToStr/Comment.nvim/issues/22
    use({
      "numToStr/Comment.nvim",
      config = require("plugins.comment"),
    })

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
      config = function()
        -- disable default mapping
        vim.g.doge_mapping = ""
      end,
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

    -- Markdown preview
    use({
      "iamcco/markdown-preview.nvim",
      run = ":call mkdp#util#install()",
      ft = { "markdown" },
    })

    use({
      "ellisonleao/glow.nvim",
      opt = true,
      cmd = { "Glow", "GlowInstall" },
    })

    ---------------------------------
    -- Compilation, Test and Debug --
    ---------------------------------

    -- Code runner
    -- NOTE: doesn't support many languages, nor REPL mode
    -- ALT: https://github.com/michaelb/sniprun (full file support?)
    use({
      "arjunmahishi/run-code.nvim",
      config = function()
        local map = require("utils").map
        map({ "v", "\\r", "<CMD>RunCodeSelected<CR>" })
        map({ "n", "\\r", "<CMD>RunCodeFile<CR>" })
        vim.cmd("au FileType markdown nmap \\r <CMD>RunCodeBlock<CR>")
      end,
    })

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
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "b0o/schemastore.nvim",
      },
      config = require("lsp.install").setup,
    })

    -- Java LSP
    use("mfussenegger/nvim-jdtls")

    -- Rust tools
    -- TODO: setup
    use({
      "simrat39/rust-tools.nvim",
      disable = true,
      requires = {
        "neovim/nvim-lspconfig",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap",
      },
    })

    -- LSP diagnostics, code actions, formatting extensions
    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        {
          "ThePrimeagen/refactoring.nvim",
          requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
          },
        },
      },
      config = require("lsp.null").setup,
    })

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
        { "kdheepak/cmp-latex-symbols" }, -- TODO: lazy load
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
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})
