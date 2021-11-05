-- https://github.com/folke/which-key.nvim --
-- TODO: separate bindings

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

  -- Move line(s) up/down
  map({ "n", "<A-j>", ":move .+1<CR>==" })
  map({ "n", "<A-k>", ":move .-2<CR>==" })
  map({ "v", "<A-j>", ":move '>+1<CR>gv=gv" })
  map({ "v", "<A-k>", ":move '<-2<CR>gv=gv" })

  -- Duplicate line(s)
  map({ "n", "<A-d>", ":co .<CR>==" })
  map({ "v", "<A-d>", ":co '><CR>gv=gv" })

  -- Select all
  -- map({ "n", "<c-a>", "ggVG" })
  -- map({ "n", "<C-A>", "<CMD>%+y<CR>" })

  M.misc()
end

function M.misc()
  -- LSP
  map({ "n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>" })
  -- Telescope
  map({ "n", "<C-_>", "<CMD>Telescope current_buffer_fuzzy_find<CR>" }) -- control slash NOTE: inverse order
  -- NvimTree
  map({ "n", ";", "<CMD>NvimTreeToggle<CR>" })
  -- Dial
  map({ "n", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "n", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "<C-a>", "<Plug>(dial-increment)", noremap = false })
  map({ "v", "<C-x>", "<Plug>(dial-decrement)", noremap = false })
  map({ "v", "g<C-a>", "<Plug>(dial-increment-additional)", noremap = false })
  map({ "v", "g<C-x>", "<Plug>(dial-decrement-additional)", noremap = false })
  -- Visual indent
  map({ "v", "<", "<gv" })
  map({ "v", ">", ">gv" })
end

function M.which_key()
  -- TODO: visual mode mappings?
  local wk = require("which-key")
  -- Config
  wk.setup({
    layout = {
      align = "center",
    },
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
        m = { "<CMD>lua require'lsp.test'.custom_test_method()<CR>", "Test method" },
        c = { "<CMD>lua require'lsp.test'.custom_test_class()<CR>", "Test class" },
      },
      l = {
        name = "+lsp",
        d = { "<CMD>Telescope lsp_definitions<CR>", "goto definition" },
        D = { "<CMD>lua vim.lsp.buf.declaration()<CR>", "goto Declaration" },
        r = { "<CMD>Telescope lsp_references<CR>", "list references" },
        i = { "<CMD>Telescope lsp_implementations<CR>", "list implementations" },
        t = { "<CMD>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
        s = { "<CMD>Telescope lsp_document_symbols<CR>", "show document symbols" },
        S = { "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>", "show dynamic workspace symbols" },
        R = { "<CMD>lua vim.lsp.buf.rename()<CR>", "rename symbol" },
        f = { "<CMD>gf<CR>", "goto file" },
        F = { "<CMD>gF<CR>", "goto file (with line number)" },
        l = { "<CMD>Trouble lsp_document_diagnostics<CR>", "show document diagnostics" },
        L = { "<CMD>Trouble lsp_workspace_diagnostics<CR>", "show workspace diagnostics" },
        K = { "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "show line diagnostics" },
        q = { "<CMD>lua require('plugins.telescope').code_action()<CR>", "code actions" },
        Q = { "<CMD>Telescope lsp_range_code_actions<CR>", "code actions (range)" },
        [";"] = { "<CMD>ToggleDiag<CR>", "toggle diagnostics" },
      },
      f = {
        name = "+find",
        b = { "<CMD>Telescope buffers<CR>", "search buffers" },
        c = { "<CMD>lua require'plugins.telescope'.dotconfig()<CR>", "search config" },
        e = { "<CMD>lua require'plugins.telescope'.explorer()<CR>", "file explorer" },
        f = { "<CMD>lua require'plugins.telescope'.file_search()<CR>", "find files" },
        h = { "<CMD>Telescope help_tags<CR>", "help" },
        H = { "<CMD>Telescope vim_options<CR>", "vim options" },
        o = { "<CMD>Telescope oldfiles<CR>", "old files" },
        g = { "<CMD>Telescope live_grep<CR>", "live grep" },
        r = { "<CMD>Telescope registers<CR>", "registers" }, -- could be "
        t = { "<CMD>Telescope colorscheme<CR>", "theme" },
        m = { "<CMD>Telescope man_pages<CR>", "search manual" },
        n = { "<CMD>NnnExplorer<CR>", "nnn explorer" },
        N = { "<CMD>NnnPicker<CR>", "nnn picker" },
        s = { "<CMD>Telescope spell_suggest<CR>", "spelling" },
        S = { "1z=", "spelling correct" },
        k = { "<CMD>Telescope keymaps<CR>", "find keymaps" },
        q = { "<CMD>TodoTrouble<CR>", "find todos (Trouble)" },
        Q = { "<CMD>TodoTelescope<CR>", "find todos (Telescope)" },
        p = { "<CMD>Telescope media_files<CR>", "media files" },
        y = { "<CMD>Telescope neoclip<CR>", "yank clipboard manager" },
        ["/"] = { "<CMD>Telescope search_history<CR>", "search history" },
        [";"] = { "<CMD>Telescope command_history<CR>", "command history" },
        ["."] = { "<CMD>Telescope resume<CR>", "resume last command" },
        -- TODO: grep_string
      },
      -- TODO: set up g for Telescope git_*
      g = {
        name = "+git",
        [";"] = { "git blame toggle" },
        g = { "<CMD>FloatermNew lazygit<CR>", "lazygit" },
        h = { "git stage hunk" },
        r = { "git reset hunk" },
        R = { "git reset buffer" },
        d = { "git diff preview" },
        u = { "git stage hunk undo" },
        s = { "<CMD>Telescope git_stash<CR>", "git stash" },
        b = { "<CMD>Telescope git_branches<CR>", "git branches" },
        c = { "<CMD>Telescope git_bcommits<CR>", "git commits (buffer)" },
        C = { "<CMD>Telescope git_commits<CR>", "git commits (repo)" },
        y = { "git yank reference url" },
        Y = { "<CMD>lua require'gitlinker'.get_repo_url()<CR>", "git yank repo url" },
        w = {
          "<CMD>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
          "git browse reference url",
        },
        W = {
          "<CMD>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
          "git browse repo url",
        },
        ["?"] = { "<CMD>Telescope git_status<CR>", "git status" },
      },
      h = {
        name = "+hop",
        c = { "<CMD>:HopChar1<CR>", "char 1" },
        C = { "<CMD>:HopChar2<CR>", "Char 2" },
        w = { "<CMD>:HopWord<CR>", "word" },
        l = { "<CMD>:HopLine<CR>", "line" },
        h = { "<CMD>:HopPattern<CR>", "pattern" },
      },
      r = {
        -- n = { "<CMD>lua vim.lsp.buf.rename()<CR>", "rename symbol" },
        n = { "<CMD>lua require'lsp.rename'()<CR>", "rename symbol" },
        r = { "<CMD>FloatermNew lazydocker<CR>", "lazydocker" },
      },
      s = { "<CMD>Dashboard<CR>", "Dashboard" },
      z = { "<CMD>ZenMode<CR>", "Zen Mode" },
      p = { ":lua print(vim.inspect())<LEFT><LEFT>", "lua print", silent = false },
      P = { ":lua require'notify'()<LEFT>", "lua notify", silent = false },
      q = { ":lua require'notify'.dismiss()<CR>", "dismiss notifications" },
      u = { "<CMD>UndotreeToggle<CR>", "Undo Tree" },
      ["/"] = { "<CMD>DogeGenerate<CR>", "Generate DocString" },
      ["?"] = { "<CMD>Telescope keymaps<CR>", "Keymaps" },
      [";"] = { "<CMD>MinimapToggle<CR>", "Minimap" },
      ["<space>"] = { "<CMD>lua require'nvim-biscuits'.toggle_biscuits()<CR>", "Toggle Biscuits" },
    },
    ["["] = {
      name = "+previous",
      g = { "Previous git hunk" },
      d = { "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>", "Previous diagnostic" },
      t = { "<CMD>call ultest#positions#prev()<CR>", "Previous test" },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = { "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic" },
      t = { "<CMD>call ultest#positions#next()<CR>", "Next test" },
    },
    g = {
      name = "+g",
      K = { "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostics" },
      l = { "<CMD>Trouble lsp_document_diagnostics<CR>", "Show document diagnostics" },
      L = { "<CMD>Trouble lsp_workspace_diagnostics<CR>", "Show workspace diagnostics" },
      q = { "<CMD>lua require('plugins.telescope').code_action()<CR>", "Code actions" },
      d = { "<CMD>Telescope lsp_definitions<CR>", "Goto definition" },
      D = { "<CMD>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      r = { "<CMD>Telescope lsp_references<CR>", "References" },
      i = { "<CMD>Telescope lsp_implementations<CR>", "Implementations" },
      t = { "<CMD>lua vim.lsp.buf.type_definition()<CR>", "Type definition" },
      s = { "<CMD>Telescope lsp_document_symbols<CR>", "Document symbols" },
      S = { "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>", "Dynamic workspace symbols" },
      -- S = { "<CMD>Telescope lsp_workspace_symbols<CR>" },
      F = { "<CMD>edit <cfile><CR>", "Open file reference" },
    },
    ["\\"] = {
      -- tpope/unimpaired has [<Space> and ]<Space> as well
      O = { "O<ESC>", "Create new line above" },
      o = { "o<ESC>", "Create new line below" },
    },
  })
end

return M
