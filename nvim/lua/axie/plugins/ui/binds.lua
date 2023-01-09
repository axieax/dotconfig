local M = {}

-- TODO: separate bindings
-- Normal and Visual mappings on same key
-- Can use Packer module field to lazy load based on lua require

function M.config()
  require("which-key").setup({
    layout = { align = "center" },
    window = { winblend = 20 },
    -- For modes.nvim
    -- plugins = {
    --   presets = {
    --     operators = false,
    --   },
    -- },
  })
end

function M.general_mappings()
  -- mappings
  local wk = require("which-key")
  wk.register({
    ["<space>"] = {
      name = "Space",
      d = {
        name = "+debug",
      },
      t = {
        name = "+test",
        -- v = { "<Cmd>TestVisit<CR>", "Test visit" }, -- vim-test
      },
      l = {
        name = "+lsp",
        d = { require("telescope.builtin").lsp_definitions, "goto definition" },
        D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "goto Declaration" },
        r = { require("telescope.builtin").lsp_references, "list references" },
        i = { require("telescope.builtin").lsp_implementations, "list implementations" },
        t = { "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
        s = { require("telescope.builtin").lsp_document_symbols, "show document symbols" },
        S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "show dynamic workspace symbols" },
        R = { vim.lsp.buf.rename, "rename symbol" },
        -- f = { "gf", "goto file" },
        -- F = { "gF", "goto file (with line number)" },
        l = { "<Cmd>Trouble document_diagnostics<CR>", "show document diagnostics" },
        L = { "<Cmd>Trouble workspace_diagnostics<CR>", "show workspace diagnostics" },
        c = { vim.lsp.codelens.run, "code lens" },
        [";"] = { "<Cmd>ToggleDiag<CR>", "toggle diagnostics" },
        ["?"] = { "<Cmd>LspInfo<CR>", "LSP info" },
      },
      f = {
        name = "+find",
        a = { require("telescope.builtin").symbols, "find symbols" },
        b = { require("telescope.builtin").buffers, "open buffers" },
        z = { "<Cmd>Telescope zoxide list<CR>", "zoxide list" },
        v = { require("telescope.builtin").vim_options, "vim options" },
        r = { require("telescope.builtin").registers, "registers" }, -- could be "
        -- M = { require("telescope").extensions.macroscope.default, "search macros" },
        M = { "<Cmd>Telescope macroscope<CR>", "search macros" },
        -- TODO: n for notes?
        s = { "1z=", "spelling correct" },
        S = { require("telescope.builtin").spell_suggest, "spelling suggestions" },
        q = { "<Cmd>TodoTrouble<CR>", "find todos (Trouble)" },
        Q = { "<Cmd>TodoTelescope<CR>", "find todos (Telescope)" },
        -- P = { require("telescope").extensions.projects.projects, "recent projects" },
        P = { "<Cmd>Telescope projects<CR>", "recent projects" },
        -- y = { require("telescope").extensions.neoclip.default, "yank clipboard manager" },
        y = { "<Cmd>Telescope neoclip<CR>", "yank clipboard manager" },
        ["?"] = { require("telescope.builtin").commands, "commands" },
        ["/"] = { require("telescope.builtin").search_history, "search history" },
        [";"] = { require("telescope.builtin").command_history, "command history" },
      },
      o = {
        q = { "<Cmd>copen<CR>", "open qflist" },
        Q = { "<Cmd>Copen<CR>", "open qflist (vim-dispatch)" },
        l = { "<Cmd>lopen<CR>", "open loclist" },
      },
      p = { ":lua =", "lua print", silent = false },
      P = { ":lua require'axie.utils'.notify()<LEFT>", "lua notify", silent = false },
      q = { require("axie.utils").toggle_signcolumn, "toggle signcolumn" },
      a = { ":lua require'hlargs'.toggle()<CR>", "toggle argument highlights" },
      v = { "ggVG", "select all" },
      V = {
        function()
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.api.nvim_cmd({
            cmd = "normal",
            bang = true,
            args = { 'ggVG"+y' },
          }, {})
          vim.api.nvim_win_set_cursor(0, pos)
        end,
        "copy all to clipboard",
      },
      i = { "<Cmd>IndentBlanklineToggle<CR>", "toggle indent context line" },
      ["?"] = { require("telescope.builtin").keymaps, "Keymaps" },
      ["\\"] = { "<Cmd>lua require'specs'.show_specs()<CR>", "Accent cursor" },
    },
    ["["] = {
      name = "+previous",
      d = {
        function()
          vim.diagnostic.goto_prev({ float = { border = "rounded" } })
        end,
        "Previous diagnostic",
      },
    },
    ["]"] = {
      name = "+next",
      d = {
        function()
          vim.diagnostic.goto_next({ float = { border = "rounded" } })
        end,
        "Next diagnostic",
      },
    },
    g = {
      name = "+g",
      l = { "<Cmd>Trouble document_diagnostics<CR>", "Show document diagnostics" },
      L = { "<Cmd>Trouble workspace_diagnostics<CR>", "Show workspace diagnostics" },
      q = { "<Cmd>lua require'axie.lsp.code_actions'.native(true)<CR>", "code actions (ignore null-ls)" },
      Q = { "<Cmd>lua require'axie.lsp.code_actions'.native(false)<CR>", "code actions (all)" },
      s = { require("telescope.builtin").lsp_document_symbols, "Document symbols" },
      S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Dynamic workspace symbols" },
      -- S = { require'telescope.builtin'.lsp_workspace_symbols },
      -- F = { "<Cmd>edit <cfile><CR>", "Open file reference" },
    },
    ["\\"] = {
      -- tpope/unimpaired has [<Space> and ]<Space> as well
      O = { "O<ESC>", "Create new line above" },
      o = { "o<ESC>", "Create new line below" },
      s = {
        function()
          vim.o.spell = not vim.o.spell
        end,
        "Toggle spellcheck",
      },
    },
    [","] = {
      s = { "<Cmd>StartupTime<CR>", "startup time" },
    },
  })
end

function M.register_git_bindings()
  local wk = require("which-key")
  wk.register({
    name = "+git",
    h = { require("gitsigns").stage_hunk, "git stage hunk" },
    H = { "<Cmd>DiffviewFileHistory .<CR>", "git stage hunk" },
    K = { require("gitsigns").preview_hunk, "git hunk preview" },
    r = { require("gitsigns").reset_hunk, "git reset hunk" },
    R = { require("gitsigns").reset_buffer, "git reset buffer" },
    d = { require("gitsigns").diffthis, "git diff view" },
    -- d = { "<Cmd>DiffviewOpen<CR>", "git diff view open" },
    -- D = { "<Cmd>DiffviewOpen main<CR>", "git diff view close" }, -- main / master
    -- D = { "<Cmd>DiffviewClose<CR>", "git diff view close" },
    x = { require("gitsigns").toggle_deleted, "git virtual deleted" },
    m = { "git merge conflict" }, -- TODO: MERGE CONFLICTS
    u = { require("gitsigns").undo_stage_hunk, "git stage hunk undo" },
    s = { require("telescope.builtin").git_stash, "git stash" },
    b = { require("telescope.builtin").git_branches, "git branches" },
    c = { require("telescope.builtin").git_bcommits, "git commits (buffer)" },
    C = { require("telescope.builtin").git_commits, "git commits (repo)" },
    y = { "git yank reference url" },
    Y = { require("gitlinker").get_repo_url, "git yank repo url" },
    w = {
      function()
        require("gitlinker").get_buf_range_url("n", {
          action_callback = require("gitlinker.actions").open_in_browser,
        })
      end,
      "git browse reference url",
    },
    W = {
      function()
        require("gitlinker").get_repo_url({
          action_callback = require("gitlinker.actions").open_in_browser,
        })
      end,
      "git browse repo url",
    },
    ["?"] = { require("telescope.builtin").git_status, "git status" },
  }, {
    prefix = "<space>g",
  })

  -- visual bindings
  wk.register({
    name = "+git",
    h = {
      function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      "git stage hunk",
    },
    r = {
      function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      "git reset hunk",
    },
  }, {
    prefix = "<space>g",
    mode = "v",
  })
end

return M
