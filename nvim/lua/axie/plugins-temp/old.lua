return {
  "utility",
  "general",
  "ui",
}

    -----------------------
    -- General Utilities --
    -----------------------
    local general_utilities = function(use)
      -- Search for TODO comments and Trouble pretty list
      use({
        "folke/todo-comments.nvim",
        requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
      }, "notes")

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
      use({ "mong8se/actually.nvim", disable = require("axie.utils.config").dev_mode })
    end
    general_utilities(remote_use)

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
              brightness_up = "<Leader>sk",
              brightness_down = "<Leader>sj",
              toggle = "<Leader>ss",
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

      -- Preview line jumps
      use({
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
          require("numb").setup({ number_only = true })
        end,
      })
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

    -----------------------------------
    -- General Programming Utilities --
    -----------------------------------
    local general_programming_utilities = function(use)
      -- Interactive scratchpad with virtual text
      -- ALT: https://github.com/michaelb/sniprun
      use("metakirby5/codi.vim")

      -- Align lines by character
      use("godlygeek/tabular", "tabular")
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
      local debug = require("axie.lsp.debug")
      use({
        "mfussenegger/nvim-dap",
        config = debug.dap_config,
      })

      -- Debugger Telescope extension
      use({
        "nvim-telescope/telescope-dap.nvim",
        after = { "nvim-dap", "telescope.nvim" },
        config = debug.dap_telescope_config,
      })

      -- Debugger UI
      use({
        "rcarriga/nvim-dap-ui",
        after = "nvim-dap",
        config = debug.dapui_config,
      })

      use({
        "theHamsta/nvim-dap-virtual-text",
        after = { "nvim-dap", "nvim-treesitter" },
        config = debug.dap_virtual_text_config,
      })

      -- Debugger installer
      use("Pocco81/dap-buddy.nvim")

      -- Language-specific debugger setup
      use({
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = debug.dap_python_config,
      })
    end
    compilation_test_debug(remote_use)

    -------------------
    -- LSP Utilities --
    -------------------
    local lsp_utilities = function(use)
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

      -- LSP diagnostics lines
      use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        disable = true,
        config = function()
          local lsp_lines = require("lsp_lines")
          lsp_lines.setup()
          vim.diagnostic.config({ virtual_text = false })
          vim.keymap.set("", "<Space>l", lsp_lines.toggle, { desc = "toggle lsp lines" })
        end,
      })

      -- LSP diagnostics toggle
      use({
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        config = function()
          require("toggle_lsp_diagnostics").init()
        end,
      })

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
