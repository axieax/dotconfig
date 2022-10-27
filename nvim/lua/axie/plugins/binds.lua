local M = {}

-- TODO: separate bindings
-- Normal and Visual mappings on same key
-- Can use Packer module field to lazy load based on lua require

function M.config()
  local wk = require("which-key")
  -- Config
  wk.setup({
    layout = { align = "center" },
    window = { winblend = 20 },
    -- For modes.nvim
    -- plugins = {
    --   presets = {
    --     operators = false,
    --   },
    -- },
  })

  require("axie.plugins.binds").general_mappings()
  require("axie.plugins.binds").register_git_bindings()
  require("axie.plugins.binds").misc()
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
        K = {
          function()
            vim.diagnostic.open_float(0, { border = "rounded" })
          end,
          "show line diagnostics",
        },
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
      r = {
        n = { require("axie.lsp.rename").rename_empty, "rename symbol (no default text)" },
        N = { vim.lsp.buf.rename, "rename symbol" },
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
      V = { 'ggVG"+y', "copy all to clipboard" }, -- TODO: add <c-o> only if has jumped?
      c = { require("axie.utils").display_path, "buffer path" },
      C = { require("axie.utils").display_cwd, "cwd" },
      i = { "<Cmd>IndentBlanklineToggle<CR>", "toggle indent context line" },
      ["?"] = { require("telescope.builtin").keymaps, "Keymaps" },
      ["\\"] = { "<Cmd>lua require'specs'.show_specs()<CR>", "Accent cursor" },
      ["<Tab>"] = { "<Cmd>AerialToggle<CR>", "Aerial Symbols" },
    },
    ["["] = {
      name = "+previous",
      g = { "Previous git hunk" },
      d = {
        function()
          vim.diagnostic.goto_prev({ float = { border = "rounded" } })
        end,
        "Previous diagnostic",
      },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = {
        function()
          vim.diagnostic.goto_next({ float = { border = "rounded" } })
        end,
        "Next diagnostic",
      },
    },
    g = {
      name = "+g",
      K = {
        function()
          -- TODO: use `customise_handler` from axie.lsp.config
          local _, winnr = vim.diagnostic.open_float({ border = "rounded" })
          if winnr then
            vim.api.nvim_win_set_option(winnr, "winblend", 20)
          end
        end,
        "Show line diagnostics",
      },
      l = { "<Cmd>Trouble document_diagnostics<CR>", "Show document diagnostics" },
      L = { "<Cmd>Trouble workspace_diagnostics<CR>", "Show workspace diagnostics" },
      q = { "<Cmd>lua require'axie.lsp.code_actions'.native(true)<CR>", "code actions (ignore null-ls)" },
      Q = { "<Cmd>lua require'axie.lsp.code_actions'.native(false)<CR>", "code actions (all)" },
      d = { require("telescope.builtin").lsp_definitions, "Goto definition" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      r = { require("telescope.builtin").lsp_references, "References" },
      i = { require("telescope.builtin").lsp_implementations, "Implementations" },
      t = { "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
      s = { require("telescope.builtin").lsp_document_symbols, "Document symbols" },
      S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Dynamic workspace symbols" },
      -- S = { require'telescope.builtin'.lsp_workspace_symbols },
      F = { "<Cmd>edit <cfile><CR>", "Open file reference" },
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
    q = { require("gitsigns").toggle_numhl, "git gutter colour toggle" },
    [";"] = { require("gitsigns").toggle_current_line_blame, "git blame toggle" },
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

function M.misc()
  local filetype_map = require("axie.utils").filetype_map
  local require_args = require("axie.utils").require_args
  local code_actions = require("axie.lsp.code_actions").native
  -- LSP
  vim.keymap.set("n", "K", vim.lsp.buf.hover)
  -- NOTE: conflicts with default formatting keybind
  vim.keymap.set({ "n", "v" }, "gq", require_args(code_actions, true), { desc = "code actions (ignore null-ls)" })
  vim.keymap.set({ "n", "v" }, "gQ", require_args(code_actions, false), { desc = "code actions (all)" })
  -- Visual indent
  vim.keymap.set("v", "<", "<gv")
  vim.keymap.set("v", ">", ">gv")
  -- Others
  filetype_map("markdown", "v", ",*", "S*gvS*", { remap = true, desc = "bold selection" })
  vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "unindent" })
  vim.keymap.set("n", "<Space>e", "<Cmd>edit<CR>", { desc = "refresh buffer" })
end

return M
