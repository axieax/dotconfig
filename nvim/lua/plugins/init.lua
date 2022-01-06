--[[ Inspiration
-- https://github.com/rockerBOO/awesome-neovim
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/modules.md#list-of-modules
-- https://github.com/siduck76/NvChad theme
-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html
-- TODO: https://github.com/jose-elias-alvarez/dotfiles/blob/main/config/nvim/lua/plugins/init.lua
-- TODO: https://github.com/numToStr/dotfiles/blob/master/neovim/.config/nvim/lua/numToStr/plugins.lua
-- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/options.lua
-- https://github.com/Gelio/ubuntu-dotfiles/blob/master/install/neovim/stowed/.config/nvim/lua/lsp/tsserver.lua#L13
--]]

--[[ TODO
-- PRIORITY: Separate treesitter and telescope extensions, use Packer sequencing (after)
-- PRIORITY: set up https://github.com/renerocksai/telekasten.nvim
-- PRIORITY: eslint/eslint_d not working
-- IMPORTANT: group which-key bindings
-- IMPORTANT: lsp bindings into on_attach
-- IMPORTANT: util map function use which-key (pcall) https://github.com/neovim/neovim/pull/16594
-- IMPORTANT: uncomment adjacent lines https://github.com/numToStr/Comment.nvim/issues/22
-- IMPORTANT: set up toggleterm
-- TODO: use bufferline https://www.youtube.com/watch?v=vJAmjAax2H0
-- TODO: use vim-fugitive instead of gitlinker?
-- TODO: ]n or ]b next note / todo (todo-commments go to next bookmark)
-- TODO: Telescope picker for LSP commands
-- TODO: lsp-rename no pre-filled text (<space>rN), transparent window?
-- TODO: fix lspinstaller html server
-- TODO: <space>lU to update lsp servers?
-- TODO: rust-tools debug setup
-- TODO: global toggle inlay hints command (inc rust as well)
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
-- surround nvim = vim sandwich + vim surround?
-- https://github.com/stevearc/stickybuf.nvim
-- TODO: lsp config separate into install, setup, utils
-- TODO: toggle cmp
-- List prereqs
-- TODO: bind for telescope sessions
-- Tab before indent spot jumps to correct indent spot
-- Relative line number disabled ft manually defined?
--]]

--[[ Features/plugins
-- Highlight text temporarily https://www.reddit.com/r/neovim/comments/rmq4gd/is_there_an_alternative_to_vimmark_to_colorize/
-- LSPCommands Telescope interface
-- https://github.com/ii14/lsp-command ?
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
-- windline instead of galaxyline?
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
-- https://github.com/kwkarlwang/bufresize.nvim
-- https://github.com/sQVe/sort.nvim
-- https://github.com/strboul/urlview.vim
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- https://github.com/NTBBloodbath/rest.nvim API
-- PackerUpdate force pull (git fetch origin, git reset --hard origin/master)
--]]

--[[ Notes / issues
-- Zen mode with nvim-treesitter-context?
-- stabilize.nvim view jumps
    -- https://github.com/luukvbaal/stabilize.nvim/issues/3
    -- https://github.com/booperlv/nvim-gomove/issues/1
    -- floats may be closed soon after nvim startup (e.g. Telescope, lazygit)
-- Markdown issues - code block cindent, normal nocindent (<CR> on normal line gets extra indent)
-- Markdown header folds https://github.com/nvim-treesitter/nvim-treesitter/issues/2145, https://github.com/plasticboy/vim-markdown
-- https://www.reddit.com/r/neovim/comments/r8qcxl/nvimcmp_deletes_the_first_word_after_autocomplete/
-- https://github.com/hrsh7th/nvim-cmp/issues/611
-- inccommand split preview-window scroll
-- nvim-cmp treesitter completion source vs buffer source?
-- Opening buffer for file (nvim-tree) replaces barbar buffers
-- Markdown TS Parser (https://github.com/MDeiml/tree-sitter-markdown)
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/872
-- Colorizer disabled on PackerCompile, no support for lowercase, unmaintained
-- LSP format, autopairs may start to break after a while
--]]

--[[ Current PRs
-- https://github.com/NTBBloodbath/galaxyline.nvim/pull/31 (ignore lsp clients from provider)
-- https://github.com/NTBBloodbath/galaxyline.nvim/pull/32 (short line mid section)
--]]

-- https://github.com/wbthomason/packer.nvim --

-- Autoinstall packer
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local auto_install = vim.fn.empty(vim.fn.glob(packer_path)) > 0
if auto_install then
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
end

-- Automatically source this file on save
vim.cmd("autocmd BufWritePost */dotconfig/nvim/*/*.lua source <afile>")

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
      config = function()
        local impatient = require("impatient")
        impatient.enable_profile()
      end,
    })

    -- Filetype config (faster startup and custom overrides)
    use("nathom/filetype.nvim")

    -------------
    -- Theming --
    -------------

    use({
      "marko-cerovac/material.nvim",
      config = require("themes.material"),
    })

    use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = require("themes.catppuccin"),
    })

    use({
      "rebelot/kanagawa.nvim",
      config = require("themes.kanagawa"),
    })

    -- ALT: https://github.com/ful1e5/onedark.nvim
    use({
      "olimorris/onedarkpro.nvim",
      config = require("themes.onedark"),
    })

    use({
      "folke/tokyonight.nvim",
      config = require("themes.tokyonight"),
    })

    use({
      "Mofiqul/dracula.nvim",
      config = require("themes.dracula"),
    })

    use({
      "EdenEast/nightfox.nvim",
      config = require("themes.nightfox"),
    })

    use({
      "bluz71/vim-nightfly-guicolors",
      config = require("themes.nightfly"),
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
    -- ALT: https://github.com/windwp/windline.nvim
    use({
      "NTBBloodbath/galaxyline.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      after = "onedarkpro.nvim",
      config = require("plugins.galaxyline").setup,
    })

    -- Tabline
    use({
      "romgrk/barbar.nvim",
      -- disable = true,
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
    -- ALT: https://github.com/startup-nvim/startup.nvim
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
    -- POSSIBLE: can this use vim.ui.select?
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

    -- Treesitter text dimming
    -- NOTE: Twilight background issue https://github.com/folke/twilight.nvim/issues/15#issuecomment-912146776
    use({
      "folke/twilight.nvim",
      cmd = { "Twilight" },
      config = function()
        require("twilight").setup()
        -- NOTE: this does not work
        vim.cmd("hi Twilight guibg=NONE")
      end,
    })

    -- Focus mode
    use({
      "folke/zen-mode.nvim",
      cmd = { "ZenMode" },
      requires = { "folke/twilight.nvim", "lewis6991/gitsigns.nvim" },
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
      config = require("plugins.notify"),
    })

    -- Better quickfix list
    use({
      "kevinhwang91/nvim-bqf",
      ft = "qf",
    })

    -- Stabilise buffers
    use({
      "luukvbaal/stabilize.nvim",
      disable = true,
      config = function()
        -- for stabilising quickfix list (trouble.nvim)
        require("stabilize").setup({
          nested = "QuickFixCmdPost,DiagnosticChanged *",
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
    -- ALT: https://github.com/nvim-neo-tree/neo-tree.nvim
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

    -- Shade inactive windows
    -- NOTE: doesn't work with transparent backgrounds https://github.com/sunjon/Shade.nvim/issues/7
    use({
      "sunjon/shade.nvim",
      disable = true,
      config = function()
        require("shade").setup({
          overlay_opacity = 90,
          opacity_step = 1,
          keys = {
            -- leader z instead of s?
            brightness_up = "<leader>sk",
            brightness_down = "<leader>sj",
            toggle = "<leader>ss",
          },
        })
      end,
    })

    -- vim.ui overrides
    use({
      "stevearc/dressing.nvim",
      config = require("plugins.dressing"),
    })

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

    -- Function context indicator
    -- NOTE: doesn't play well with some plugins
    use({
      "romgrk/nvim-treesitter-context",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("treesitter-context").setup({
          patterns = {
            --[[ default = {
              "class",
              "function",
              "method",
              -- 'for', -- These won't appear in the context
              -- 'while',
              -- 'if',
              -- 'switch',
              -- 'case',
            }, ]]
            -- BUG: not working (TS: content not nested under heading)
            markdown = {
              "atx_heading",
            },
          },
        })
      end,
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
    use({
      "karb94/neoscroll.nvim",
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

    -- Text movement
    use({
      "booperlv/nvim-gomove",
      config = function()
        require("gomove").setup({
          -- whether to not to move past line when moving blocks horizontally, (true/false)
          move_past_end_col = false,
        })
      end,
    })

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

    -- Git diff and history view
    -- NOTE: can be wrapped with https://github.com/TimUntersberger/neogit
    use({
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
    })

    -----------------------------------
    -- General Programming Utilities --
    -----------------------------------

    -- Language parser + syntax highlighting
    -- TODO: automatically install parsers for new file types (don't download all)
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = require("plugins.treesitter").setup,
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
      requires = "nvim-treesitter/nvim-treesitter",
    })

    -- Treesitter text subjects
    use({
      "RRethy/nvim-treesitter-textsubjects",
      requires = "nvim-treesitter/nvim-treesitter",
    })

    -- GitHub Copilot
    use({
      "github/copilot.vim",
      config = require("plugins.copilot"),
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

    -- Auto continue bullets
    -- NOTE: ctrl-t to indent after auto continue, ctrl-d to unindent
    use("dkarter/bullets.vim")

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
      cmd = { "PasteImg" },
      config = require("plugins.pasteimage"),
    })

    -- Markdown preview
    use({
      "iamcco/markdown-preview.nvim",
      run = ":call mkdp#util#install()",
      ft = { "markdown" },
      cmd = "MarkdownPreview",
    })

    use({
      "ellisonleao/glow.nvim",
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
        "simrat39/rust-tools.nvim",
      },
      config = require("lsp.install").setup,
    })

    -- Java LSP
    use("mfussenegger/nvim-jdtls")

    -- Rust tools
    use({
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
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
      config = require("lsp.aerial"),
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
