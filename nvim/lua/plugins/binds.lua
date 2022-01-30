-- https://github.com/folke/which-key.nvim --
-- TODO: separate bindings
-- Normal and Visual mappings on same key

local M = {}
local map = require("utils").map

function M.general()
  -- Set leader key
  -- vim.g.mapleader = ","

  -- Terminal normal mode
  -- map("t", "<ESC>", "<C-\\><C-n>", opts)

  -- Source
  -- NOTE: PackerInstall requires restarting nvim
  -- vim.cmd("command! R :luafile $MYVIMRC<CR>:PackerCompile<CR>")
  vim.cmd("command! R :luafile $MYVIMRC<CR>")
  -- nvim_add_user_command("R", ":luafile $MYVIMRC<CR>")

  -- Space mappings
  M.register_git_bindings()
  M.misc()
end

function M.register_git_bindings()
  require("which-key").register({
    name = "+git",
    g = { require("plugins.toggleterm").lazygit, "lazygit" },
    h = { require("gitsigns").stage_hunk, "git stage hunk" },
    H = { "<CMD>DiffviewFileHistory .<CR>", "git stage hunk" },
    K = { require("gitsigns").preview_hunk, "git hunk preview" },
    r = { require("gitsigns").reset_hunk, "git reset hunk" },
    R = { require("gitsigns").reset_buffer, "git reset buffer" },
    d = { require("gitsigns").diffthis, "git diff view" },
    -- d = { "<CMD>DiffviewOpen<CR>", "git diff view open" },
    -- D = { "<CMD>DiffviewOpen main<CR>", "git diff view close" }, -- main / master
    -- D = { "<CMD>DiffviewClose<CR>", "git diff view close" },
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
  require("which-key").register({
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
  -- LSP
  map({ "n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>" })
  map({ "v", "gq", ":lua require'plugins.telescope'.code_action()<CR>" })
  -- Telescope
  map({ "n", "<C-_>", "<CMD>Telescope current_buffer_fuzzy_find<CR>" }) -- control slash NOTE: inverse order
  -- NvimTree
  map({ "n", ";", "<CMD>NvimTreeToggle<CR>" })
  -- Dial
  -- TODO: https://github.com/monaqa/dial.nvim/issues/7 (cursor doesn't move)
  map({ "n", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "n", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "v", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "g<C-a>", "<Plug>(dial-increment-additional)", noremap = false })
  map({ "v", "g<C-x>", "<Plug>(dial-decrement-additional)", noremap = false })
  -- Visual indent
  map({ "v", "<", "<gv" })
  map({ "v", ">", ">gv" })
  -- Source
  map({ "n", "<space>rf", "<CMD>luafile %<CR>" })
  map({ "n", "<space>rF", "<CMD>source % | PackerCompile<CR>" })
  -- Markdown bold
  map({ "v", ",*", "S*gvS*", noremap = false })
  -- Shift tab to unindent
  map({ "i", "<S-Tab>", "<C-d>" })
end

function M.which_key()
  local wk = require("which-key")
  -- Config
  wk.setup({
    layout = { align = "center" },
    window = { winblend = 20 },
  })

  -- mappings
  wk.register({
    ["<space>"] = {
      name = "Space",
      d = {
        name = "+debug",
        -- TODO: up down bindings
        p = { "<CMD>lua require'dap'.run_last()<CR>", "Run last" },
        b = { "<CMD>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
        B = {
          "<CMD>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
          "Breakpoint set conditional",
        },
        j = { "<CMD>lua require'dap'.step_out()<CR>", "Step out" },
        k = { "<CMD>lua require'dap'.step_into()<CR>", "Step into" },
        l = { "<CMD>lua require'dap'.step_over()<CR>", "Step over" },
        q = { "<CMD>lua require'dap'.close()<CR>", "Stop" },
        c = { "<CMD>Telescope dap configurations<CR>", "Configurations" },
        h = { "<CMD>Telescope dap commands<CR>", "Commands" },
        f = { "<CMD>Telescope dap frames<CR>", "Frames" },
        v = { "<CMD>Telescope dap variables<CR>", "Variables" },
        ["/"] = { "<CMD>Telescope dap list_breakpoints<CR>", "List breakpoints" },
        [";"] = { "<CMD>lua require'dapui'.toggle()<CR>", "Toggle UI" },
        t = { "<CMD>lua require'lsp.debug.helpers'.debug_test()<CR>", "Debug test" },
      },
      t = {
        name = "+test",
        f = { "<CMD>Ultest<CR>", "Ultest file" },
        F = { "<CMD>UltestDebug<CR>", "Ultest file debug" },
        t = { "<CMD>UltestNearest<CR>", "Ultest nearest" },
        T = { "<CMD>UltestDebugNearest<CR>", "Ultest nearest debug" },
        p = { "<CMD>UltestOutput<CR>", "Ultest output" },
        [";"] = { "<CMD>lua require'lsp.test'.custom_test_summary()<CR>", "Test summary" },
        v = { "<CMD>TestVisit<CR>", "Test visit" },
        m = { require("lsp.test").custom_test_method, "Test method" },
        c = { "<CMD>lua require'lsp.test'.custom_test_class()<CR>", "Test class" },
      },
      l = {
        name = "+lsp",
        d = { require("telescope.builtin").lsp_definitions, "goto definition" },
        D = { "<CMD>lua vim.lsp.buf.declaration()<CR>", "goto Declaration" },
        r = { require("telescope.builtin").lsp_references, "list references" },
        i = { require("telescope.builtin").lsp_implementations, "list implementations" },
        I = { "<CMD>LspInstallInfo<CR>", "LSP installer" },
        t = { "<CMD>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
        s = { require("telescope.builtin").lsp_document_symbols, "show document symbols" },
        S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "show dynamic workspace symbols" },
        R = { vim.lsp.buf.rename, "rename symbol" },
        f = { "<CMD>gf<CR>", "goto file" },
        F = { "<CMD>gF<CR>", "goto file (with line number)" },
        l = { "<CMD>Trouble document_diagnostics<CR>", "show document diagnostics" },
        L = { "<CMD>Trouble workspace_diagnostics<CR>", "show workspace diagnostics" },
        K = {
          function()
            vim.diagnostic.open_float(0, { border = "rounded" })
          end,
          "show line diagnostics",
        },
        q = { require("plugins.telescope").code_action, "code actions" },
        Q = { require("telescope.builtin").lsp_range_code_actions, "code actions (range)" },
        c = { vim.lsp.codelens.run, "code lens" },
        [";"] = { "<CMD>ToggleDiag<CR>", "toggle diagnostics" },
        ["?"] = { "<CMD>LspInfo<CR>", "LSP info" },
      },
      f = {
        name = "+find",
        a = { require("telescope.builtin").symbols, "find symbols" },
        b = { require("telescope.builtin").buffers, "search buffers" },
        c = { require("plugins.telescope").dotconfig, "search config" },
        e = { "<CMD>Telescope file_browser grouped=true<CR>", "file explorer" },
        E = { "<CMD>Telescope env<CR>", "environment variables" },
        z = { "<CMD>Telescope zoxide list<CR>", "zoxide list" },
        f = { require("plugins.telescope").file_search, "find files" },
        F = {
          function()
            require("plugins.telescope").file_search(true)
          end,
          "find all files",
        },
        h = { require("telescope.builtin").help_tags, "help" },
        H = { require("telescope.builtin").vim_options, "vim options" },
        o = { require("telescope.builtin").oldfiles, "old files" },
        O = { "<CMD>SessionManager load_session<CR>", "find sessions" },
        g = { require("telescope.builtin").live_grep, "live grep" },
        G = { require("telescope.builtin").grep_string, "grep string" },
        r = { require("telescope.builtin").registers, "registers" }, -- could be "
        t = { require("telescope.builtin").colorscheme, "theme" },
        T = { "<CMD>Telescope colorscheme enable_preview=true<CR>", "theme preview" },
        m = { require("telescope.builtin").man_pages, "search manual" },
        -- M = { require("telescope").extensions.macroscope.default, "search macros" },
        M = { "<CMD>Telescope macroscope<CR>", "search macros" },
        -- TODO: n for notes
        s = { "1z=", "spelling correct" },
        S = { require("telescope.builtin").spell_suggest, "spelling suggestions" },
        k = { require("telescope.builtin").keymaps, "find keymaps" },
        q = { "<CMD>TodoTrouble<CR>", "find todos (Trouble)" },
        Q = { "<CMD>TodoTelescope<CR>", "find todos (Telescope)" },
        -- p = { require("telescope").extensions.media_files.media_files, "media files" },
        p = { "<CMD>Telescope media_files<CR>", "media files" },
        -- P = { require("telescope").extensions.projects.projects, "recent projects" },
        P = { "<CMD>Telescope projects<CR>", "recent projects" },
        -- y = { require("telescope").extensions.neoclip.default, "yank clipboard manager" },
        y = { "<CMD>Telescope neoclip<CR>", "yank clipboard manager" },
        ["?"] = { require("telescope.builtin").commands, "commands" },
        ["/"] = { require("telescope.builtin").search_history, "search history" },
        [";"] = { require("telescope.builtin").command_history, "command history" },
        ["."] = { require("telescope.builtin").resume, "resume last command" },
      },
      r = {
        n = { require("lsp.rename").rename_empty, "rename symbol (no default text)" },
        N = { vim.lsp.buf.rename, "rename symbol" },
        r = { require("plugins.toggleterm").lazydocker, "lazydocker" },
        -- BUG: the following places an extra character in the buffer (replace)
        -- f = { "<CMD>luafile %<CR>" },
        -- F = { "<CMD>source % | PackerCompile<CR>" },
      },
      o = {
        q = { "<CMD>copen<CR>", "open qflist" },
        Q = { "<CMD>Copen<CR>", "open qflist (vim-dispatch)" },
        l = { "<CMD>lopen<CR>", "open loclist" },
      },
      s = { "<CMD>PackerSync<CR>", "Update Plugins" },
      S = { "<CMD>Alpha<CR>", "Start Menu" },
      z = { "<CMD>ZenMode<CR>", "Zen Mode" },
      Z = { "<CMD>Twilight<CR>", "Twilight Toggle" },
      p = { ":lua require'utils'.display()<LEFT>", "lua print", silent = false },
      P = { ":lua require'utils'.notify()<LEFT>", "lua notify", silent = false },
      q = { require("utils").toggle_signcolumn, "toggle signcolumn" },
      Q = { require("notify").dismiss, "dismiss notifications" },
      u = { "<CMD>MundoToggle<CR>", "Undo Tree" },
      v = { "ggVG", "select all" },
      V = { 'ggVG"+y', "copy all to clipboard" },
      c = { require("utils").display_path, "buffer path" },
      C = { require("utils").display_cwd, "cwd" },
      i = { "<CMD>IndentBlanklineToggle<CR>", "toggle indent context line" },
      ["/"] = { "<CMD>DogeGenerate<CR>", "Generate DocString" },
      ["?"] = { require("telescope.builtin").keymaps, "Keymaps" },
      [";"] = { "<CMD>MinimapToggle<CR>", "Minimap" },
      ["<space>"] = { "<CMD>lua require'nvim-biscuits'.toggle_biscuits()<CR>", "Toggle Biscuits" },
      ["<tab>"] = { "<CMD>AerialToggle<CR>", "Symbols Outline" },
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
      t = { "<CMD>call ultest#positions#prev()<CR>", "Previous test" },
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
      t = { "<CMD>call ultest#positions#next()<CR>", "Next test" },
    },
    g = {
      name = "+g",
      K = {
        function()
          vim.diagnostic.open_float(0, { border = "rounded" })
        end,
        "Show line diagnostics",
      },
      l = { "<CMD>Trouble document_diagnostics<CR>", "Show document diagnostics" },
      L = { "<CMD>Trouble workspace_diagnostics<CR>", "Show workspace diagnostics" },
      q = { require("plugins.telescope").code_action, "Code actions" },
      Q = { vim.lsp.buf.code_action, "Code actions (default)" },
      d = { require("telescope.builtin").lsp_definitions, "Goto definition" },
      D = { "<CMD>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      r = { require("telescope.builtin").lsp_references, "References" },
      i = { require("telescope.builtin").lsp_implementations, "Implementations" },
      t = { "<CMD>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
      s = { require("telescope.builtin").lsp_document_symbols, "Document symbols" },
      S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Dynamic workspace symbols" },
      -- S = { require'telescope.builtin'.lsp_workspace_symbols },
      F = { "<CMD>edit <cfile><CR>", "Open file reference" },
    },
    ["\\"] = {
      -- tpope/unimpaired has [<Space> and ]<Space> as well
      O = { "O<ESC>", "Create new line above" },
      o = { "o<ESC>", "Create new line below" },
    },
    [","] = {
      p = { "<CMD>PasteImg<CR>", "Paste image" },
      o = { "<CMD>Glow<CR>", "Markdown preview (glow)" },
      O = { "<CMD>MarkdownPreview<CR>", "Markdown preview (browser)" },
      ["["] = { require("plugins.treesitter").goto_prev_sibling, "Goto previous sibling node" },
      ["]"] = { require("plugins.treesitter").goto_next_sibling, "Goto next sibling node" },
      ["{"] = { require("plugins.treesitter").goto_parent, "Goto parent node" },
      ["}"] = { require("plugins.treesitter").goto_child, "Goto child node" },
    },
  })
end

return M
