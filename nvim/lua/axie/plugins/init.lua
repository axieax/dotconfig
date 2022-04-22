-- https://github.com/wbthomason/packer.nvim --

return function(dev_mode)
  -- Bootstrap packer
  local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  local auto_install = vim.fn.empty(vim.fn.glob(packer_path)) > 0
  if auto_install then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
  end
  vim.cmd("packadd packer.nvim")

  -- Automatically source lua config files on save
  vim.cmd("autocmd! BufWritePost */dotconfig/nvim/**/*.lua,*/.config/nvim/**/*.lua source $MYVIMRC")

  local packer = require("packer")
  return packer.startup({
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
          -- BUG: this breaks DistantInstall for some reason
          impatient.enable_profile()
        end,
      })

      -- Filetype config (faster startup and custom overrides)
      -- ISSUE: https://github.com/nathom/filetype.nvim/issues/9
      -- use("nathom/filetype.nvim")

      -- CursorHold event fix
      use("antoinemadec/FixCursorHold.nvim")

      -- Remove mapping escape delay
      use({
        "max397574/better-escape.nvim",
        config = function()
          require("better_escape").setup({
            mapping = { "jk", "kj" },
          })
        end,
      })

      ----------------
      -- My Plugins --
      ----------------

      -- View buffer URLs
      use({
        "axieax/urlview.nvim",
        disable = dev_mode,
        -- cmd = { "UrlView" },
        config = require("axie.plugins.urlview"),
      })

      -------------
      -- Theming --
      -------------

      -- TRY: https://www.reddit.com/r/neovim/comments/se377t/telescopenvim_looks_neat

      -- TODO: replace all with themer.lua?
      use({
        "themercorp/themer.lua",
        disable = true,
        config = require("axie.themes.themer"),
      })

      use({
        "marko-cerovac/material.nvim",
        config = require("axie.themes.material"),
      })

      use({
        "catppuccin/nvim",
        as = "catppuccin",
        config = require("axie.themes.catppuccin"),
      })

      use({
        "rebelot/kanagawa.nvim",
        config = require("axie.themes.kanagawa"),
      })

      -- TODO: replace (too red)
      -- ALT: https://github.com/navarasu/onedark.nvim
      use({
        "olimorris/onedarkpro.nvim",
        config = require("axie.themes.onedark"),
      })

      use({
        "folke/tokyonight.nvim",
        config = require("axie.themes.tokyonight"),
      })

      use({
        "Mofiqul/dracula.nvim",
        config = require("axie.themes.dracula"),
      })

      use({
        "EdenEast/nightfox.nvim",
        config = require("axie.themes.nightfox"),
      })

      use({
        "bluz71/vim-nightfly-guicolors",
        config = require("axie.themes.nightfly"),
      })

      -----------------------
      -- General Utilities --
      -----------------------

      -- Keybinds
      use({
        "folke/which-key.nvim",
        config = require("axie.plugins.binds").setup,
      })

      -- Fuzzy finder
      -- EXTENSIONS: https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
      use({
        "nvim-telescope/telescope.nvim",
        requires = {
          { "nvim-lua/plenary.nvim" },
          -- Extensions
          { "nvim-telescope/telescope-symbols.nvim" },
          { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
          { "nvim-telescope/telescope-dap.nvim" },
          { "nvim-telescope/telescope-media-files.nvim" },
          { "nvim-telescope/telescope-file-browser.nvim" },
          { "LinArcX/telescope-env.nvim" },
          { "ahmedkhalf/project.nvim" },
          { "jvgrootveld/telescope-zoxide" },
          -- { "nvim-telescope/telescope-node-modules.nvim" },
          { "mfussenegger/nvim-dap" },
          { "rcarriga/nvim-notify" },
          { "stevearc/aerial.nvim" },
          { "tknightz/telescope-termfinder.nvim" },
          -- { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = require("axie.plugins.telescope").setup,
      })

      -- Search for TODO comments and Trouble pretty list
      use({
        "folke/todo-comments.nvim",
        requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
        config = require("axie.plugins.notes"),
      })

      -- Scrollbar
      use({
        "petertriho/nvim-scrollbar",
        after = "nvim-hlslens",
        config = require("axie.plugins.scrollbar"),
      })

      -- Extra mappings (with encoding/decoding as well)
      use("tpope/vim-unimpaired")

      -- "." repeat for some commands
      use("tpope/vim-repeat")

      -- Statusline
      -- ALT: https://github.com/windwp/windline.nvim
      -- ALT: https://github.com/tamton-aquib/staline.nvim
      use({
        "NTBBloodbath/galaxyline.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        after = "onedarkpro.nvim",
        config = require("axie.plugins.galaxyline").setup,
      })

      -- Tabline
      use({
        "romgrk/barbar.nvim",
        -- disable = true,
        requires = "kyazdani42/nvim-web-devicons",
        config = require("axie.plugins.barbar"),
      })

      use({
        "akinsho/bufferline.nvim",
        disable = true,
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
          require("bufferline").setup()
        end,
      })

      -- Terminal
      use({
        "akinsho/toggleterm.nvim",
        config = require("axie.plugins.toggleterm").setup,
      })

      -- Startup screen
      -- ALT: https://github.com/startup-nvim/startup.nvim
      use({
        "goolord/alpha-nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = require("axie.plugins.start"),
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
        end,
      })

      -- Fold preview
      use({
        "anuvyklack/pretty-fold.nvim",
        config = function()
          require("pretty-fold").setup({})
          -- require("pretty-fold.preview").setup_keybinding()
          -- TODO: toggle keybinding
          require("axie.utils").map({ "n", "zK", "<CMD>lua require'pretty-fold.preview'.show_preview()<CR>" })
          -- require("axie.utils").map({ "n", "zK", "<CMD>lua require'pretty-fold.preview'.keymap_open_close('zK')<CR>" })
          -- require("axie.utils").map({ "n", "<esc>", "<CMD>lua require'pretty-fold.preview'.keymap_close('<esc>')<CR>" })
        end,
      })

      -- Emacs Orgmode
      -- ALT: vimwiki (more for notes/diary), neorg (too different from md)
      -- NOTE: https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md#getting-started-with-orgmode
      -- POSSIBLE: can this use vim.ui.select?
      -- TRY: https://github.com/nvim-neorg/neorg-telescope
      -- TRY: https://github.com/danymat/neorg-gtd-things
      use({
        "nvim-orgmode/orgmode",
        requires = {
          "nvim-treesitter/nvim-treesitter",
          "akinsho/org-bullets.nvim",
        },
        config = function()
          local orgmode = require("orgmode")
          orgmode.setup_ts_grammar()
          orgmode.setup({
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
          -- TEMP: transparent background issue above
          local tw_config = require("twilight.config")
          local tw_colors = tw_config.colors
          tw_config.colors = function(...)
            tw_colors(...)
            vim.cmd("hi! Twilight guibg=NONE")
          end
        end,
      })

      -- Focus mode
      use({
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
        requires = { "folke/twilight.nvim", "lewis6991/gitsigns.nvim" },
        config = require("axie.plugins.zen"),
      })

      -- Minimap
      -- INSTALL: yay -S code-minimap
      use({
        "wfxr/minimap.vim",
        cmd = {
          "Minimap",
          "MinimapClose",
          "MinimapToggle",
          "MinimapRefresh",
          "MinimapUpdateHighlight",
        },
      })

      -- Undo history
      use({
        "simnalamburt/vim-mundo",
        config = require("axie.plugins.undo"),
      })

      -- Clipboard manager
      use({
        "AckslD/nvim-neoclip.lua",
        requires = { "tami5/sqlite.lua", module = "sqlite" },
        after = "telescope.nvim",
        config = function()
          require("neoclip").setup({
            enable_persistent_history = true,
          })
          require("telescope").load_extension("neoclip")
        end,
      })

      -- Notification
      use({
        "rcarriga/nvim-notify",
        config = require("axie.plugins.notify"),
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

      -- Focused splits
      use({
        "beauwilliams/focus.nvim",
        event = "BufEnter",
        config = require("axie.plugins.focus"),
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

      -- Lua documentation
      use("milisims/nvim-luaref")

      -------------------
      -- File Explorer --
      -------------------

      -- Tree explorer (filesystem, buffers, git_status)
      use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main",
        requires = {
          "nvim-lua/plenary.nvim",
          "kyazdani42/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
        config = require("axie.plugins.neotree"),
      })

      -- nnn file explorer
      use({
        "luukvbaal/nnn.nvim",
        disable = true,
        config = function()
          require("nnn").setup({
            explorer = { side = "botright" },
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
        -- module = "dial.map",
        config = require("axie.plugins.dial"),
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

      -- cursor jump accent
      use("rainbowhxch/beacon.nvim")

      -- vim.ui overrides
      use({
        "stevearc/dressing.nvim",
        config = require("axie.plugins.dressing"),
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
        config = require("axie.plugins.indentline"),
      })

      -- Scope context indicator
      use({
        "code-biscuits/nvim-biscuits",
        requires = "nvim-treesitter/nvim-treesitter",
        config = require("axie.plugins.biscuits"),
      })

      -- Function context indicator
      -- NOTE: doesn't play well with some plugins
      use({
        "lewis6991/nvim-treesitter-context",
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
              -- BUG: not working (treesitter: content not nested under heading)
              -- https://github.com/romgrk/nvim-treesitter-context/issues/87
              markdown = { "atx_heading" },
            },
          })
        end,
      })

      -- Argument highlights
      use({
        "m-demare/hlargs.nvim",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
          require("hlargs").setup({
            -- Catppuccin Flamingo
            color = "#F2CDCD",
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
      -- ALT: augroup with vim.lsp.buf.document_highlight and vim.lsp.buf.clear_references
      -- NOTE: this uses words instead of symbols (which LSP uses)
      use({
        "osyo-manga/vim-brightest",
        config = function()
          -- Highlight group (e.g. BrighestUndercurl)
          vim.g["brightest#highlight"] = { group = "BrightestUnderline" }
        end,
      })

      -- CSS colours
      -- NOTE: doesn't highlight lower case names (#18)
      -- WARN: unmaintained
      -- ALT: https://github.com/RRethy/vim-hexokinase
      -- ISSUE: disappears on PackerCompile (probably because of event refresh?)
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
        config = require("axie.plugins.hlslens").setup,
      })

      -- Preview line jumps
      use({
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
          require("numb").setup({ number_only = true })
        end,
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
      -- CHECK: letters based on characters in word?
      -- TRY: find a way / alt for jumping by starting to type word at location
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

      -- Matching text navigation
      use({
        "andymass/vim-matchup",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
      })

      -- Tab out
      use({
        "abecodes/tabout.nvim",
        requires = "nvim-treesitter/nvim-treesitter",
        config = require("axie.plugins.tabout"),
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
        config = require("axie.plugins.gitsigns"),
      })

      -- Git repo link
      use({
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = require("axie.plugins.gitlinker"),
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
        config = require("axie.plugins.treesitter").setup,
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
      -- ALT: https://github.com/zbirenbaum/copilot.lua with https://github.com/zbirenbaum/copilot-cmp
      use({
        "github/copilot.vim",
        config = require("axie.plugins.copilot"),
      })

      -- Interactive scratchpad with virtual text
      -- ALT: https://github.com/michaelb/sniprun
      use("metakirby5/codi.vim")

      -- Align lines by character
      use({
        "godlygeek/tabular",
        config = require("axie.plugins.tabular").setup,
      })

      -- Commenting
      -- NOTE: missing uncomment adjacent (gcgc, gcu)
      -- https://github.com/numToStr/Comment.nvim/issues/22
      use({
        "numToStr/Comment.nvim",
        config = require("axie.plugins.comment"),
      })

      -- Better commentstring (for vim-commentary)
      use({
        "JoosepAlviste/nvim-ts-context-commentstring",
        requires = "nvim-treesitter/nvim-treesitter",
      })

      -- Surround with brackets
      use("tpope/vim-surround")

      -- Snippets
      -- TODO: check out Ultisnips for custom snippets

      -- Snippet engine
      use({
        "L3MON4D3/LuaSnip",
        requires = "rafamadriz/friendly-snippets", -- snippet collection
        config = require("axie.lsp.snippets").setup,
      })

      -- Docstring generator
      -- ALT: https://github.com/kkoomen/vim-doge
      -- ALT: https://github.com/nvim-treesitter/nvim-tree-docs
      use({
        "danymat/neogen",
        requires = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
        config = function()
          require("neogen").setup({ snippet_engine = "luasnip" })
        end,
      })

      -- Autoclose and autorename html tag
      use({
        "windwp/nvim-ts-autotag",
        requires = "nvim-treesitter/nvim-treesitter",
      })

      -- Regular expression explainer
      use({
        "bennypowers/nvim-regexplainer",
        requires = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        config = require("axie.plugins.regexplainer"),
      })

      -- Auto continue bullets
      -- NOTE: ctrl-t to indent after auto continue, ctrl-d to unindent
      use("dkarter/bullets.vim")

      -- Dim unused variables and functions
      use({
        "narutoxy/dim.lua",
        requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
        config = function()
          require("dim").setup()
        end,
      })

      -- package.json dependency manager
      -- TODO: can it check vulnerabilities?
      use({
        "vuki656/package-info.nvim",
        requires = "MunifTanjim/nui.nvim",
        ft = { "json" },
        config = require("axie.plugins.package"),
      })

      -- Python indenting issues
      use("Vimjas/vim-python-pep8-indent")

      -- Markdown LaTeX paste image
      -- NOTE: requires xclip (X11), wl-clipboard (Wayland) or pngpaste (MacOS)
      use({
        "ekickx/clipboard-image.nvim",
        cmd = { "PasteImg" },
        config = require("axie.plugins.pasteimage"),
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
        config = function()
          vim.g.glow_border = "rounded"
        end,
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
          local map = require("axie.utils").map
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
        config = require("axie.lsp.test").setup,
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
        config = require("axie.lsp.debug"),
      })

      -- Debugger installer
      use("Pocco81/DAPInstall.nvim")

      -------------------
      -- LSP Utilities --
      -------------------

      -- LSP config
      use({
        "neovim/nvim-lspconfig",
        config = require("axie.lsp.config"),
      })

      -- LSP install
      use({
        "williamboman/nvim-lsp-installer",
        requires = {
          "hrsh7th/cmp-nvim-lsp",
          "stevearc/aerial.nvim",
          -- ALT: https://github.com/jose-elias-alvarez/typescript.nvim ?
          "jose-elias-alvarez/nvim-lsp-ts-utils",
          "b0o/schemastore.nvim",
          "simrat39/rust-tools.nvim",
        },
        config = require("axie.lsp.install").setup,
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

      -- TODO: https://github.com/p00f/clangd_extensions.nvim

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
        config = require("axie.lsp.null").setup,
      })

      -- LSP progress indicator
      use({
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({
            window = {
              relative = "editor",
              blend = 0,
            },
          })
        end,
      })

      -- LSP diagnostics toggle
      use({
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        config = function()
          require("toggle_lsp_diagnostics").init()
        end,
      })

      -- Symbols outline
      use({
        "stevearc/aerial.nvim",
        config = require("axie.lsp.aerial"),
      })

      use({
        "simrat39/symbols-outline.nvim",
        config = function()
          vim.g.symbols_outline = {
            -- highlight_hovered_item = false,
            auto_close = true,
            auto_preview = false,
            -- instant_preview = true,
            border = "rounded",
            winblend = 15,
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
        config = require("axie.plugins.lightbulb").setup,
      })

      -- Completion menu
      -- TODO: move sources out with after = "nvim-cmp" (https://github.com/danymat/champagne/blob/main/lua/plugins.lua)
      use({
        "hrsh7th/nvim-cmp",
        requires = {
          { "windwp/nvim-autopairs" },
          { "L3MON4D3/LuaSnip", requires = "rafamadriz/friendly-snippets" },
          { "saadparwaiz1/cmp_luasnip" },
          { "lukas-reineke/cmp-under-comparator" },
          { "onsails/lspkind-nvim" },
          { "hrsh7th/cmp-nvim-lsp" },
          { "hrsh7th/cmp-nvim-lua" },
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-calc" },
          { "hrsh7th/cmp-emoji" },
          -- { "hrsh7th/cmp-cmdline" },
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
        config = require("axie.lsp.completion"),
      })

      -- Function signature
      use({
        "ray-x/lsp_signature.nvim",
        config = require("axie.lsp.signature"),
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
        config = require("axie.plugins.firenvim"),
      })

      -- Packer auto update + compile
      if auto_install then
        packer.sync()
      end
    end,

    config = {
      -- https://github.com/wbthomason/packer.nvim/issues/202
      max_jobs = 50,
      -- https://github.com/wbthomason/packer.nvim/issues/381#issuecomment-849815901
      -- git = {
      --   subcommands = {
      --     update = "pull --ff-only --progress --rebase",
      --   },
      -- },
      profile = { enable = true },
      autoremove = true,
      display = {
        open_fn = function()
          return require("packer.util").float({ border = "rounded" })
        end,
      },
    },
  })
end
