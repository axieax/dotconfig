-- Bootstrap packer
local P = require("axie.plugins.packer")
local bootstrapped = P.auto_bootstrap()

local packer = require("packer")
return packer.startup({
  function(packer_use)
    local remote_use = P.customise_use(packer_use, false)
    local local_use = P.customise_use(packer_use, true)
    P.setup()

    ---------------------
    -- Setup Utilities --
    ---------------------
    local setup_utilities = function(use)
      -- Packer can manage itself
      use("wbthomason/packer.nvim")

      -- Improve and measure startup time
      use({
        "lewis6991/impatient.nvim",
        config = function()
          local impatient = require("impatient")
          impatient.enable_profile()
        end,
      })

      -- Measure startup time
      use("dstein64/vim-startuptime", "startuptime")

      -- Remove mapping escape delay
      use({
        "max397574/better-escape.nvim",
        config = function()
          require("better_escape").setup({ mapping = { "jk", "kj" } })
        end,
      })
    end
    setup_utilities(remote_use)

    ----------------
    -- My Plugins --
    ----------------
    local my_plugins = function(use)
      -- View buffer URLs
      use({
        "axieax/urlview.nvim",
        -- cmd = { "UrlView" },
      }, "urlview")
    end
    my_plugins(local_use)

    -------------
    -- Theming --
    -------------
    local theming = function(use)
      -- TODO: replace all with themer.lua?
      use({
        "themercorp/themer.lua",
        disable = true,
      }, "themes.themer")

      use({
        "marko-cerovac/material.nvim",
      }, "themes.material")

      use({
        "catppuccin/nvim",
        as = "catppuccin",
      }, "themes.catppuccin")

      use({
        "sam4llis/nvim-tundra",
        disable = true,
      }, "themes.tundra")

      use({
        "rebelot/kanagawa.nvim",
        disable = true,
      }, "themes.kanagawa")

      -- TODO: replace (too red)
      -- ALT: https://github.com/navarasu/onedark.nvim
      use({
        "olimorris/onedarkpro.nvim",
      }, "themes.onedark")
    end
    theming(remote_use)

    -----------------------
    -- General Utilities --
    -----------------------
    local general_utilities = function(use)
      -- Keybinds
      use("folke/which-key.nvim", "binds")

      -- Fuzzy finder
      -- TODO: lazy load with `module`, breaks indentline and lastplace
      -- NOTE: setup calls `telescope.builtin`
      -- EXTENSIONS: https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
      use({
        "nvim-telescope/telescope.nvim",
        requires = {
          { "nvim-lua/plenary.nvim" },
          -- Extensions
          { "nvim-telescope/telescope-symbols.nvim" },
          { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
      }, "telescope")

      -- Tree explorer (filesystem, buffers, git_status)
      use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main",
        requires = {
          "nvim-lua/plenary.nvim",
          "kyazdani42/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
      }, "neotree")

      -- Neo-tree diagnostics source
      use({
        "mrbjarksen/neo-tree-diagnostics.nvim",
        requires = "nvim-neo-tree/neo-tree.nvim",
        module = "neo-tree.sources.diagnostics",
      })

      -- Telescope file browser
      use({
        "nvim-telescope/telescope-file-browser.nvim",
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          local require_args = require("axie.utils").require_args
          telescope.load_extension("file_browser")
          vim.keymap.set(
            "n",
            "<Space>fe",
            require_args(telescope.extensions.file_browser.file_browser, { grouped = true }),
            { desc = "file explorer" }
          )
        end,
      })

      use({
        "jvgrootveld/telescope-zoxide",
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          -- TEMP: zoxide override mappings
          -- https://github.com/jvgrootveld/telescope-zoxide/issues/12
          require("telescope._extensions.zoxide.config").setup({
            mappings = {
              ["<C-b>"] = {
                keepinsert = true,
                action = function(selection)
                  pcall(function(path)
                    telescope.extensions.file_browser.file_browser({
                      cwd = path,
                    })
                  end, selection.path)
                end,
              },
            },
          })
          telescope.load_extension("zoxide")
        end,
      })

      -- Media file preview
      use({
        "nvim-telescope/telescope-media-files.nvim",
        requires = {
          "nvim-lua/popup.nvim", -- NOTE: not necessary?
          "nvim-lua/plenary.nvim",
        },
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          -- NOTE: config in telescope setup
          telescope.load_extension("media_files")
          vim.keymap.set("n", "<Space>fp", telescope.extensions.media_files.media_files, { desc = "media files" })
        end,
      })

      -- Environment variables
      use({
        "LinArcX/telescope-env.nvim",
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          telescope.load_extension("env")
          vim.keymap.set("n", "<Space>fE", telescope.extensions.env.env, { desc = "environment variables" })
        end,
      })

      -- Search for TODO comments and Trouble pretty list
      use({
        "folke/todo-comments.nvim",
        requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
      }, "notes")

      -- Scrollbar
      use({
        "petertriho/nvim-scrollbar",
        after = "nvim-hlslens",
        event = "BufRead",
      }, "scrollbar")

      -- Extra mappings (with encoding/decoding as well)
      use("tpope/vim-unimpaired")

      -- "." repeat for some commands
      use("tpope/vim-repeat")

      -- Statusline
      -- FORK: https://github.com/glepnir/galaxyline.nvim
      -- ALT: https://github.com/windwp/windline.nvim
      -- ALT: https://github.com/tamton-aquib/staline.nvim
      use({
        "NTBBloodbath/galaxyline.nvim",
        requires = "kyazdani42/nvim-web-devicons",
      }, "galaxyline")

      -- Tabline
      use({
        "romgrk/barbar.nvim",
        event = "BufEnter",
        -- disable = true,
        requires = "kyazdani42/nvim-web-devicons",
      }, "barbar")

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
        requires = {
          "nvim-telescope/telescope.nvim",
          "tknightz/telescope-termfinder.nvim",
        },
      }, "toggleterm")

      -- Startup screen
      -- ALT: https://github.com/startup-nvim/startup.nvim
      use({
        "goolord/alpha-nvim",
        requires = "kyazdani42/nvim-web-devicons",
      }, "startscreen")

      -- Session manager
      -- ALT: https://github.com/rmagatti/auto-session with https://github.com/rmagatti/session-lens
      use({
        "Shatur/neovim-session-manager",
        requires = "nvim-lua/plenary.nvim",
        config = function()
          local session_manager = require("session_manager")
          session_manager.setup({
            autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
          })
          vim.keymap.set("n", "<Space>fO", session_manager.load_session, { desc = "find sessions" })
        end,
      })

      -- Remember last location
      -- ALT: https://github.com/farmergreg/vim-lastplace
      use({
        "ethanholz/nvim-lastplace",
        config = function()
          require("nvim-lastplace").setup()
        end,
      })

      -- Fold preview
      -- TODO: lazy load (https://neovim.discourse.group/t/examples-of-lazyloading/2897)
      use({
        "anuvyklack/pretty-fold.nvim",
        config = function()
          require("pretty-fold").setup()
        end,
      })

      use({
        "anuvyklack/fold-preview.nvim",
        requires = "anuvyklack/nvim-keymap-amend",
        config = function()
          local pretty_fold_preview = require("fold-preview")
          pretty_fold_preview.setup()

          local keymap_amend = require("keymap-amend")
          keymap_amend("n", "zK", pretty_fold_preview.mapping.show_close_preview_open_fold)
        end,
      })

      -- Emacs Orgmode
      -- ALT: vimwiki (more for notes/diary), neorg (too different from md), mind.nvim
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
      use({
        "folke/twilight.nvim",
        cmd = { "Twilight" },
        setup = function()
          vim.keymap.set("n", "<Space>Z", "<Cmd>Twilight<CR>", { desc = "dim inactive text" })
        end,
        config = function()
          require("twilight").setup()
        end,
      })

      -- Focus mode
      use({
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
      }, "zen")

      -- Undo history
      use({
        "simnalamburt/vim-mundo",
        event = "BufEnter",
      }, "undo")

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
        after = "telescope.nvim",
      }, "notify")

      -- Better quickfix list
      use({
        "kevinhwang91/nvim-bqf",
        ft = "qf",
      })

      -- Stabilise buffers
      -- TEMP: replace with `splitkeep`
      use({
        "luukvbaal/stabilize.nvim",
        config = function()
          -- for stabilising quickfix list (trouble.nvim)
          require("stabilize").setup({
            nested = "QuickFixCmdPost,DiagnosticChanged *",
          })
        end,
      })

      -- Focused splits
      -- ALT: https://github.com/anuvyklack/windows.nvim
      use({
        "beauwilliams/focus.nvim",
        event = "BufEnter",
      }, "focus")

      -- Open with sudo
      -- NOTE: eunuch requires an askpass helper, suda.vim asks for password everytime
      -- use("tpope/vim-eunuch")
      use({
        "lambdalisue/suda.vim",
        cmd = { "SudaRead", "SudaWrite" },
      })

      -- Lua documentation
      use("milisims/nvim-luaref")

      -- Lua nvim API completion
      use("folke/neodev.nvim")

      -- howdoi query
      use({
        "zane-/howdoi.nvim",
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          telescope.load_extension("howdoi")
          vim.keymap.set("n", "<Space>fH", telescope.extensions.howdoi.howdoi)
        end,
      })

      -- argument correction
      use("mong8se/actually.nvim")
    end
    general_utilities(remote_use)

    ------------------
    -- Helper Tools --
    ------------------
    local helper_tools = function(use)
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
      use({ "simonefranza/nvim-conv", event = "BufRead" })

      -- Incrementor / decrementor
      use("monaqa/dial.nvim", "dial")

      -- Keep cursor on shift (`>` or `<`) and filter (`=`)
      use({
        "gbprod/stay-in-place.nvim",
        config = function()
          require("stay-in-place").setup()
        end,
      })
    end
    helper_tools(remote_use)

    ------------------
    -- UI Utilities --
    ------------------
    local ui_utilities = function(use)
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

      -- Highlight based on mode
      use({
        "mvllow/modes.nvim",
        disable = true,
        config = function()
          require("modes").setup()
        end,
      })

      -- cursor jump accent
      use("rainbowhxch/beacon.nvim")

      -- vim.ui overrides
      use("stevearc/dressing.nvim", "dressing")

      -- Bracket coloured pairs
      -- TODO: change colourscheme, esp red?
      use({
        "p00f/nvim-ts-rainbow",
        after = "nvim-treesitter",
      })

      -- Indent context indicator
      use({
        "lukas-reineke/indent-blankline.nvim",
        after = "nvim-treesitter",
        event = "BufRead",
      }, "indentline")

      -- Scope context indicator
      use({
        "code-biscuits/nvim-biscuits",
        after = "nvim-treesitter",
      }, "biscuits")

      -- Argument highlights
      use({
        "m-demare/hlargs.nvim",
        after = "nvim-treesitter",
        config = function()
          require("hlargs").setup({
            -- Catppuccin Flamingo
            color = "#F2CDCD",
            -- NOTE: needs to be lower than Twilight.nvim's priority of 10000
            hl_priority = 9999,
          })
        end,
      })

      -- Mark indicator
      use({
        "chentoast/marks.nvim",
        config = function()
          -- m[ and m] to navigate marks
          require("marks").setup()
        end,
      })

      -- Underline word under cursor
      -- ALT: augroup with vim.lsp.buf.document_highlight and vim.lsp.buf.clear_references
      -- NOTE: this uses words instead of symbols (which LSP uses)
      use({
        "osyo-manga/vim-brightest",
        event = "BufRead",
        config = function()
          -- Highlight group (e.g. BrighestUndercurl)
          vim.g["brightest#highlight"] = { group = "BrightestUnderline" }
        end,
      })

      -- CSS colours
      -- FORK: https://github.com/norcalli/nvim-colorizer.lua
      -- ALT: https://github.com/RRethy/vim-hexokinase
      use({
        "NvChad/nvim-colorizer.lua",
        config = function()
          require("colorizer").setup()
        end,
      })

      -- Search highlights
      use("romainl/vim-cool")

      -- Search virtual text
      use("kevinhwang91/nvim-hlslens", "hlslens")

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
        event = "BufRead",
        config = function()
          require("neoscroll").setup()
          require("neoscroll.config").set_mappings({
            -- https://github.com/karb94/neoscroll.nvim/issues/55
            -- ["{"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
            -- ["}"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
            -- ["<C-y>"] = { "scroll", { "-vim.wo.scroll", "false", "0" } },
            -- ["<C-e>"] = { "scroll", { "vim.wo.scroll", "false", "0" } },
            -- https://github.com/karb94/neoscroll.nvim/issues/50
            -- ["<ScrollWheelUp>"] = { "scroll", { "-0.10", "false", "50" } },
            -- ["<ScrollWheelDown>"] = { "scroll", { "0.10", "false", "50" } },
          })
          -- vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", "<C-y>")
          -- vim.keymap.set("i", "<ScrollWheelUp>", "<C-o><C-y>")
          -- vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", "<C-e>")
          -- vim.keymap.set("i", "<ScrollWheelDown>", "<C-o><C-e>")
        end,
      })

      -- Icon picker
      use({
        "ziontee113/icon-picker.nvim",
        cmd = {
          "IconPickerInsert",
          "IconPickerNormal",
          "IconPickerYank",
        },
      }, "iconpicker")
    end
    ui_utilities(remote_use)

    ----------------------
    -- Motion Utilities --
    ----------------------
    local motion_utilities = function(use)
      -- Multiple cursors
      use("mg979/vim-visual-multi")

      -- Easy motion / navigation
      use({
        "ggandor/leap.nvim",
        event = "BufRead",
        after = "vim-repeat",
        config = function()
          require("leap").add_default_mappings()
        end,
      })

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
        event = "BufRead",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
      })

      -- Tab out
      use({
        "abecodes/tabout.nvim",
        after = "nvim-treesitter",
      }, "tabout")
    end
    motion_utilities(remote_use)

    -----------------------------
    -- Project / Git Utilities --
    -----------------------------
    local project_git_utilities = function(use)
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
      }, "gitsigns")

      -- Git repo link
      use({
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
      }, "gitlinker")

      -- GitHub issues and pull requests
      use({
        "pwntester/octo.nvim",
        requires = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim",
          "kyazdani42/nvim-web-devicons",
        },
        config = function()
          require("octo").setup()
        end,
      })

      -- Git diff and history view
      -- NOTE: can be wrapped with https://github.com/TimUntersberger/neogit
      use({
        "sindrets/diffview.nvim",
        requires = {
          "nvim-lua/plenary.nvim",
          "kyazdani42/nvim-web-devicons",
        },
      })

      -- View node modules
      use({
        "nvim-telescope/telescope-node-modules.nvim",
        after = "telescope.nvim",
        config = function()
          local telescope = require("telescope")
          telescope.load_extension("node_modules")
          vim.keymap.set("n", "<Space>fN", telescope.extensions.node_modules.list, { desc = "search node modules" })
        end,
      })
    end
    project_git_utilities(remote_use)

    -----------------------------------
    -- General Programming Utilities --
    -----------------------------------
    local general_programming_utilities = function(use)
      -- Language parser + syntax highlighting
      -- TODO: automatically install parsers for new file types (don't download all)
      use("nvim-treesitter/nvim-treesitter", "treesitter")

      -- Treesitter parser info
      use({
        "nvim-treesitter/playground",
        run = ":TSUpdate query",
        cmd = { "TSPlaygroundToggle", "TSNodeUnderCursor", "TSCaptureUnderCursor", "TSHighlightCapturesUnderCursor" },
        after = "nvim-treesitter",
      })

      -- Treesitter text objects
      use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
      })

      -- Treesitter text subjects
      use({
        "RRethy/nvim-treesitter-textsubjects",
        after = "nvim-treesitter",
      })

      -- GitHub Copilot
      -- ALT: https://github.com/zbirenbaum/copilot.lua with https://github.com/zbirenbaum/copilot-cmp
      use("github/copilot.vim", "copilot")

      -- Interactive scratchpad with virtual text
      -- ALT: https://github.com/michaelb/sniprun
      use("metakirby5/codi.vim")

      -- Align lines by character
      use("godlygeek/tabular", "tabular")

      -- Commenting
      -- NOTE: missing uncomment adjacent (gcgc, gcu)
      -- https://github.com/numToStr/Comment.nvim/issues/22
      use({
        "numToStr/Comment.nvim",
        requires = {
          -- language-aware commentstring
          { "JoosepAlviste/nvim-ts-context-commentstring", requires = "nvim-treesitter/nvim-treesitter" },
        },
      }, "comment")

      -- Surround with brackets
      use("tpope/vim-surround")

      -- Snippets
      -- TODO: check out Ultisnips for custom snippets

      -- Snippet engine
      use({
        "L3MON4D3/LuaSnip",
        requires = "rafamadriz/friendly-snippets", -- snippet collection
        config = require("axie.lsp.snippets"),
      }, "lsp.snippets")

      -- Docstring generator
      -- ALT: https://github.com/kkoomen/vim-doge
      -- ALT: https://github.com/nvim-treesitter/nvim-tree-docs
      use({
        "danymat/neogen",
        requires = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
        config = function()
          require("neogen").setup({ snippet_engine = "luasnip" })
          vim.keymap.set("n", "<Space>/", "<Cmd>Neogen<CR>", { desc = "Generate docstring" })
        end,
      })

      -- Autoclose and autorename html tag
      use({
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
      })

      -- Regular expression explainer
      use({
        "bennypowers/nvim-regexplainer",
        requires = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
      }, "regexplainer")

      -- Auto continue bullet points
      -- NOTE: <C-t> (tab) to indent after auto continue, <C-d> (dedent) to unindent
      use({
        "gaoDean/autolist.nvim",
        ft = { "markdown", "text" },
        after = "nvim-cmp", -- <CR> mapping
        config = function()
          require("autolist").setup()
        end,
      })

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
      }, "package")

      -- Python indenting issues
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      use("Vimjas/vim-python-pep8-indent")

      -- Markdown LaTeX paste image
      -- NOTE: requires xclip (X11), wl-clipboard (Wayland) or pngpaste (MacOS)
      use({
        "ekickx/clipboard-image.nvim",
        cmd = { "PasteImg" },
      }, "pasteimage")

      -- Markdown preview
      use({
        "iamcco/markdown-preview.nvim",
        ft = { "markdown" },
        cmd = "MarkdownPreview",
      }, "markdownpreview")

      use({
        "ellisonleao/glow.nvim",
        setup = function()
          local filetype_map = require("axie.utils").filetype_map
          filetype_map("markdown", "n", ",o", "<Cmd>Glow<CR>")
        end,
        config = function()
          require("glow").setup({
            border = "rounded",
            pager = false,
          })
        end,
      })
    end
    general_programming_utilities(remote_use)

    ---------------------------------
    -- Compilation, Test and Debug --
    ---------------------------------
    local compilation_test_debug = function(use)
      -- Code runner
      -- NOTE: doesn't support many languages, nor REPL mode
      -- ALT: https://github.com/michaelb/sniprun (full file support?)
      use({
        "arjunmahishi/run-code.nvim",
        cmd = { "RunCodeBlock", "RunCodeFile", "RunCodeSelected", "ReloadRunCode" },
        setup = function()
          local filetype_map = require("axie.utils").filetype_map
          vim.keymap.set("n", "\\r", "<Cmd>RunCodeFile<CR>")
          vim.keymap.set("v", "\\r", "<Cmd>RunCodeSelected<CR>")
          filetype_map("markdown", "n", "\\r", "<Cmd>RunCodeBlock<CR>")
        end,
      })

      -- Make
      use("neomake/neomake")

      -- Compiler (e.g. :Dispatch python3.9 %)
      use("tpope/vim-dispatch")

      -- Unit test
      use({
        "nvim-neotest/neotest",
        module = "neotest",
        after = "nvim-treesitter",
        requires = {
          "nvim-lua/plenary.nvim",
          "nvim-neotest/neotest-go",
          "haydenmeade/neotest-jest",
          "nvim-neotest/neotest-python",
          "nvim-neotest/neotest-plenary",
          -- "mrcjkb/neotest-haskell",
          { "nvim-neotest/neotest-vim-test", requires = "vim-test/vim-test" },
        },
      }, "lsp.test")

      -- Debug Adapter Protocol
      use({
        "mfussenegger/nvim-dap",
        config = function()
          require("dap")

          local sign = vim.fn.sign_define
          sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
          sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
          sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,
      })

      -- Debugger Telescope extension
      use({
        "nvim-telescope/telescope-dap.nvim",
        after = { "nvim-dap", "telescope.nvim" },
        config = function()
          local telescope = require("telescope")
          telescope.load_extension("dap")
          vim.keymap.set("n", "<Space>dc", telescope.extensions.dap.configurations, { desc = "configurations" })
          vim.keymap.set("n", "<Space>d?", telescope.extensions.dap.commands, { desc = "comands" })
          vim.keymap.set("n", "<Space>df", telescope.extensions.dap.frames, { desc = "frames" })
          vim.keymap.set("n", "<Space>dv", telescope.extensions.dap.variables, { desc = "variables" })
          vim.keymap.set("n", "<Space>d/", telescope.extensions.dap.list_breakpoints, { desc = "breakpoints" })
        end,
      })

      -- Debugger UI
      use({
        "rcarriga/nvim-dap-ui",
        after = "nvim-dap",
        config = function()
          require("dapui").setup()
          -- Open terminal to side
          -- NOTE: https://github.com/rcarriga/nvim-dap-ui/issues/148
          require("dap").defaults.fallback.terminal_win_cmd = "10split new"
        end,
      })

      use({
        "theHamsta/nvim-dap-virtual-text",
        after = { "nvim-dap", "nvim-treesitter" },
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      })

      -- Debugger installer
      use("Pocco81/dap-buddy.nvim")

      -- Language-specific debugger setup
      use({
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          -- SETUP: pip install debugpy
          local dap_python = require("dap-python")
          dap_python.setup()
          dap_python.test_runner = "pytest"
        end,
      })
    end
    compilation_test_debug(remote_use)

    -------------------
    -- LSP Utilities --
    -------------------
    local lsp_utilities = function(use)
      -- LSP config
      use("neovim/nvim-lspconfig", "lsp.config")

      -- LSP install
      -- TODO: move lsp setup call to axie/init.lua
      use({
        "williamboman/mason.nvim",
        requires = {
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          "neovim/nvim-lspconfig",
          "hrsh7th/cmp-nvim-lsp",
          "stevearc/aerial.nvim",
          -- ALT: https://github.com/jose-elias-alvarez/typescript.nvim ?
          "jose-elias-alvarez/nvim-lsp-ts-utils",
          "b0o/schemastore.nvim",
          "p00f/clangd_extensions.nvim",
          "folke/neodev.nvim",
        },
      }, "lsp.install")

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

      -- Clangd extensions
      use("p00f/clangd_extensions.nvim")

      -- LSP diagnostics, code actions, formatting extensions
      use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
          "nvim-lua/plenary.nvim",
          {
            "ThePrimeagen/refactoring.nvim",
            requires = {
              "nvim-lua/plenary.nvim",
              "nvim-treesitter/nvim-treesitter",
            },
          },
        },
      }, "lsp.null")

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
        after = "telescope.nvim",
      }, "lsp.aerial")

      -- Code action menu with diff preview
      use({
        "weilbith/nvim-code-action-menu",
        disable = true,
        cmd = "CodeActionMenu",
      })

      -- Code action prompt
      use({
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
      }, "lightbulb")

      -- Completion menu
      -- TODO: move sources out with after = "nvim-cmp" (https://github.com/danymat/champagne/blob/main/lua/plugins.lua)
      use({
        "hrsh7th/nvim-cmp",
        requires = {
          { "lukas-reineke/cmp-under-comparator" },
          { "windwp/nvim-autopairs" },
          { "onsails/lspkind-nvim" },
          { "L3MON4D3/LuaSnip" },
          { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
          { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
          { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
          { "hrsh7th/cmp-path", after = "nvim-cmp" },
          { "hrsh7th/cmp-calc", after = "nvim-cmp" },
          { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
          -- { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
          { "f3fora/cmp-spell", after = "nvim-cmp" },
          { "kdheepak/cmp-latex-symbols", after = "nvim-cmp" }, -- TODO: lazy load
          {
            "David-Kunz/cmp-npm",
            requires = "nvim-lua/plenary.nvim",
            after = "nvim-cmp",
            config = function()
              require("cmp-npm").setup()
            end,
          },
          {
            "petertriho/cmp-git",
            requires = "nvim-lua/plenary.nvim",
            after = "nvim-cmp",
            config = function()
              require("cmp_git").setup({ filetypes = { "*" } })
            end,
          },
          -- "ray-x/cmp-treesitter",
          -- "quangnguyen30192/cmp-nvim-tags",
          -- "tpope/vim-dadbod",
          -- "kristijanhusak/vim-dadbod-ui",
          -- "kristijanhusak/vim-dadbod-completion",
          -- "tzachar/cmp-fzy-buffer",
          -- "tzachar/cmp-fuzzy-path",
        },
      }, "lsp.completion")

      -- Function signature
      use({
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
      }, "lsp.signature")

      -- Markdown code block edit
      use({
        "AckslD/nvim-FeMaco.lua",
        cmd = "FeMaco",
        ft = "markdown",
      }, "markdowncodeblock")
    end
    lsp_utilities(remote_use)

    -------------------
    -- Miscellaneous --
    -------------------
    local miscellaneous = function(use)
      -- Browser integration
      use("glacambre/firenvim", "firenvim")
    end
    miscellaneous(remote_use)

    -- Packer auto update + compile on bootstrap
    if bootstrapped then
      packer.sync()
    end
  end,
  config = P.config,
})
