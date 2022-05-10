-- https://github.com/folke/which-key.nvim --
-- TODO: separate bindings
-- Normal and Visual mappings on same key
-- Can use Packer module field to lazy load based on lua require

local M = {}

function M.setup()
  local wk = require("which-key")
  -- Config
  wk.setup({
    layout = { align = "center" },
    window = { winblend = 20 },
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
        -- TODO: up down bindings
        p = { "<Cmd>lua require'dap'.run_last()<CR>", "Run last" },
        b = { "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
        B = {
          "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
          "Breakpoint set conditional",
        },
        j = { "<Cmd>lua require'dap'.step_out()<CR>", "Step out" },
        k = { "<Cmd>lua require'dap'.step_into()<CR>", "Step into" },
        l = { "<Cmd>lua require'dap'.step_over()<CR>", "Step over" },
        q = { "<Cmd>lua require'dap'.close()<CR>", "Stop" },
        [";"] = { "<Cmd>lua require'dapui'.toggle()<CR>", "Toggle UI" },
        t = { "<Cmd>lua require'axie.lsp.debug.helpers'.debug_test()<CR>", "Debug test" },
      },
      t = {
        name = "+test",
        f = { "<Cmd>Ultest<CR>", "Ultest file" },
        F = { "<Cmd>UltestDebug<CR>", "Ultest file debug" },
        t = { "<Cmd>UltestNearest<CR>", "Ultest nearest" },
        T = { "<Cmd>UltestDebugNearest<CR>", "Ultest nearest debug" },
        p = { "<Cmd>UltestOutput<CR>", "Ultest output" },
        [";"] = { "<Cmd>lua require'axie.lsp.test'.custom_test_summary()<CR>", "Test summary" },
        v = { "<Cmd>TestVisit<CR>", "Test visit" },
        m = { require("axie.lsp.test").custom_test_method, "Test method" },
        c = { "<Cmd>lua require'axie.lsp.test'.custom_test_class()<CR>", "Test class" },
        P = { "<Plug>PlenaryTestFile", "Plenary test file" },
      },
      l = {
        name = "+lsp",
        d = { require("telescope.builtin").lsp_definitions, "goto definition" },
        D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "goto Declaration" },
        r = { require("telescope.builtin").lsp_references, "list references" },
        i = { require("telescope.builtin").lsp_implementations, "list implementations" },
        I = { "<Cmd>LspInstallInfo<CR>", "LSP installer" },
        t = { "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
        s = { require("telescope.builtin").lsp_document_symbols, "show document symbols" },
        S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "show dynamic workspace symbols" },
        R = { vim.lsp.buf.rename, "rename symbol" },
        f = { "<Cmd>gf<CR>", "goto file" },
        F = { "<Cmd>gF<CR>", "goto file (with line number)" },
        l = { "<Cmd>Trouble document_diagnostics<CR>", "show document diagnostics" },
        L = { "<Cmd>Trouble workspace_diagnostics<CR>", "show workspace diagnostics" },
        K = {
          function()
            vim.diagnostic.open_float(0, { border = "rounded" })
          end,
          "show line diagnostics",
        },
        q = { "<Cmd>lua require'axie.lsp.code_actions'.native(true)<CR>", "code actions (ignore null-ls)" },
        Q = { "<Cmd>lua require'axie.lsp.code_actions'.native(false)<CR>", "code actions (all)" },
        c = { vim.lsp.codelens.run, "code lens" },
        [";"] = { "<Cmd>ToggleDiag<CR>", "toggle diagnostics" },
        ["?"] = { "<Cmd>LspInfo<CR>", "LSP info" },
      },
      f = {
        name = "+find",
        a = { require("telescope.builtin").symbols, "find symbols" },
        b = { require("telescope.builtin").buffers, "open buffers" },
        B = { "<Cmd>Neotree source=buffers toggle=true<CR>", "open buffers (tree)" },
        z = { "<Cmd>Telescope zoxide list<CR>", "zoxide list" },
        H = { require("telescope.builtin").vim_options, "vim options" },
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
      s = {
        function()
          local snapshot_time = os.date("!%Y-%m-%dT%TZ")
          vim.cmd("PackerSnapshot " .. snapshot_time)
          vim.cmd("PackerSync")
        end,
        "Update Plugins",
      },
      S = { "<Cmd>Alpha<CR>", "Start Menu" },
      p = { ":lua =", "lua print", silent = false },
      P = { ":lua require'axie.utils'.notify()<LEFT>", "lua notify", silent = false },
      q = { require("axie.utils").toggle_signcolumn, "toggle signcolumn" },
      a = { ":lua require'hlargs'.toggle()<CR>", "toggle argument highlights" },
      v = { "ggVG", "select all" },
      V = { 'ggVG"+y', "copy all to clipboard" },
      c = { require("axie.utils").display_path, "buffer path" },
      C = { require("axie.utils").display_cwd, "cwd" },
      i = { "<Cmd>IndentBlanklineToggle<CR>", "toggle indent context line" },
      ["?"] = { require("telescope.builtin").keymaps, "Keymaps" },
      ["\\"] = { "<Cmd>lua require'specs'.show_specs()<CR>", "Accent cursor" },
      ["<Tab>"] = { "<Cmd>AerialToggle<CR>", "Aerial Symbols" },
      ["<S-Tab>"] = { "<Cmd>SymbolsOutline<CR>", "Symbols Outline" },
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
      t = { "<Cmd>call ultest#positions#prev()<CR>", "Previous test" },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = {
        function()
          vim.diagnostic.goto_prev({ float = { border = "rounded" } })
        end,
        "Next diagnostic",
      },
      t = { "<Cmd>call ultest#positions#next()<CR>", "Next test" },
    },
    g = {
      name = "+g",
      K = {
        function()
          vim.diagnostic.open_float(0, { border = "rounded" })
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
      u = { "<Cmd>UrlView<CR>", "View buffer URLs" },
      U = { "<Cmd>UrlView packer<CR>", "View plugin URLs" },
      z = { "<Cmd>FocusMaxOrEqual<CR>", "Maximise toggle" },
      f = { "<Cmd>FocusToggle<CR>", "Focus toggle" },
      ["<tab>"] = { "<Cmd>SymbolsOutline<CR>", "Symbols Outline" },
    },
    [","] = {
      p = { "<Cmd>PasteImg<CR>", "Paste image" },
      ["["] = { require("axie.plugins.treesitter").goto_prev_sibling, "Goto previous sibling node" },
      ["]"] = { require("axie.plugins.treesitter").goto_next_sibling, "Goto next sibling node" },
      ["{"] = { require("axie.plugins.treesitter").goto_parent, "Goto parent node" },
      ["}"] = { require("axie.plugins.treesitter").goto_child, "Goto child node" },
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
    S = { "<Cmd>Neotree source=git_status toggle=true<CR>", "git status (tree)" },
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
  -- LSP
  vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  vim.keymap.set("v", "gq", "<Cmd>lua require'axie.lsp.code_actions'.native(true)<CR>")
  vim.keymap.set("v", "gQ", "<Cmd>lua require'axie.lsp.code_actions'.native(false)<CR>")
  -- Neo-tree
  vim.keymap.set("n", ";", "<Cmd>Neotree toggle=true<CR>")
  -- Visual indent
  vim.keymap.set("v", "<", "<gv")
  vim.keymap.set("v", ">", ">gv")
  -- Markdown bold
  filetype_map("markdown", "v", ",*", "S*gvS*", { noremap = false })
  -- Shift tab to unindent
  vim.keymap.set("i", "<S-Tab>", "<C-d>")
end

return M
