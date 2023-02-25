-----------------------
-- General Utilities --
-----------------------
local general_utilities = function(use)
  -- Emacs Orgmode
  -- ALT: vimwiki (more for notes/diary), neorg (too different from md), mind.nvim
  -- NOTE: https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md#getting-started-with-orgmode
  -- POSSIBLE: can this use vim.ui.select?
  -- TRY: https://github.com/nvim-neorg/neorg-telescope
  -- TRY: https://github.com/danymat/neorg-gtd-things
  -- ALT: mind.nvim
  -- NOTE: remove treesitter.lua org if not using
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
            org_agenda = "<Space>oa",
            org_capture = "<Space>oc",
          },
        },
      })
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
    -- TODO: cmds
    event = "BufEnter",
    keys = {
      { "\\f", "<Cmd>FocusToggle<CR>", desc = "Focus toggle" },
      { "\\z", "<Cmd>FocusMaxOrEqual<CR>", desc = "Maximise toggle" },
    },
    config = function()
      local colorcolumn_width = 80 -- NOTE: for some reason `tonumber(vim.o.colorcolumn)` doesn't work
      require("focus").setup({
        -- TEMP: https://github.com/beauwilliams/focus.nvim/issues/82
        autoresize = false,
        cursorline = false,
        number = false,
        signcolumn = false,
        colorcolumn = { enable = true, width = colorcolumn_width },
        excluded_filetypes = { "toggleterm", "qf", "help", "Mundo" },
      })
    end,
  })

  -- Open with sudo
  -- NOTE: eunuch requires an askpass helper, suda.vim asks for password everytime
  -- use("tpope/vim-eunuch")
  use({
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  })

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
end

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
end

-----------------------------------
-- General Programming Utilities --
-----------------------------------
local general_programming_utilities = function(use)
  -- Align lines by character
  use("godlygeek/tabular", "tabular")
end

---------------------------------
-- Compilation, Test and Debug --
---------------------------------
local compilation_test_debug = function(use)
  -- Interactive scratchpad with virtual text??
  use("metakirby5/codi.vim")

  -- Jupyter notebook

  -- Code runner
  -- NOTE: doesn't support many languages, nor REPL mode
  -- ALT: https://github.com/michaelb/sniprun (full file support?)
  -- ALT: iron.nvim
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
end

-------------------
-- LSP Utilities --
-------------------
local lsp_utilities = function(use)
  -- LSP diagnostics lines
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    disable = true,
    config = function()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()
      vim.diagnostic.config({ virtual_text = false })
      vim.keymap.set("", "<Space>l|", lsp_lines.toggle, { desc = "toggle lsp lines" })
    end,
  })

  -- Code action menu with diff preview
  use({
    "weilbith/nvim-code-action-menu",
    disable = true,
    cmd = "CodeActionMenu",
  })

  -- Markdown code block edit
  use({
    "AckslD/nvim-FeMaco.lua",
    cmd = "FeMaco",
    ft = "markdown",
    keys = { { ",e", "<Cmd>FeMaco<CR>", desc = "Edit code block" } },
    opts = {
      post_open_float = function(winnr)
        vim.api.nvim_win_set_option(winnr, "winblend", 10)
      end,
    },
  })
end
