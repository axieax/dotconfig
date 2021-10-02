-- https://github.com/folke/which-key.nvim --

local M = {}
local map = require("utils").map

function M.general()
  -- Set leader key
  -- vim.g.mapleader = ","

  -- Terminal normal mode
  -- map("t", "<Esc>", "<C-\\><C-n>", opts)

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
  -- map({ "n", "<C-A>", "<cmd>%+y<CR>" })

  M.misc()
end

function M.misc()
  -- LSP
  map({ "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" })
  -- Telescope
  vim.cmd("autocmd VimEnter * lua require('plugins.telescope').file_search(true)")
  map({ "n", "<C-_>", "<cmd>Telescope current_buffer_fuzzy_find<CR>" }) -- control slash NOTE: inverse order
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
        p = { "<cmd>lua require'dap'.run_last()<CR>", "Run last" },
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Toggle breakpoint" },
        B = {
          "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
          "Breakpoint set conditional",
        },
        j = { "<cmd>lua require'dap'.step_out()<CR>", "Step out" },
        k = { "<cmd>lua require'dap'.step_into()<CR>", "Step into" },
        l = { "<cmd>lua require'dap'.step_over()<CR>", "Step over" },
        q = { "<cmd>lua require'dap'.close()<CR>", "Stop" },
        c = { "<cmd>Telescope dap configurations<CR>", "Configurations" },
        h = { "<cmd>Telescope dap commands<CR>", "Commands" },
        f = { "<cmd>Telescope dap frames<CR>", "Frames" },
        v = { "<cmd>Telescope dap variables<CR>", "Variables" },
        ["/"] = { "<cmd>Telescope dap list_breakpoints<CR>", "List breakpoints" },
        [";"] = { "<cmd>lua require'dapui'.toggle()<CR>", "Toggle UI" },
        t = { "<cmd>lua require'lsp.debug.helpers'.debug_test()<CR>", "Debug test" },
      },
      t = {
        name = "+test",
        f = { "<cmd>Ultest<CR>", "Ultest file" },
        F = { "<cmd>UltestDebug<CR>", "Ultest file debug" },
        t = { "<cmd>UltestNearest<CR>", "Ultest nearest" },
        T = { "<cmd>UltestDebugNearest<CR>", "Ultest nearest debug" },
        p = { "<cmd>UltestOutput<CR>", "Ultest output" },
        [";"] = { "<cmd>UltestSummary<CR>", "Ultest summary" },
        v = { "<cmd>TestVisit<CR>", "Test visit" },
        m = { "<cmd>lua require'lsp.test'.custom_test_method()<CR>", "Test method" },
        c = { "<cmd>lua require'lsp.test'.custom_test_class()<CR>", "Test class" },
      },
      l = {
        name = "+lsp",
        d = { "<cmd>Telescope lsp_definitions<CR>", "goto definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "goto Definition" },
        r = { "<cmd>Telescope lsp_references<CR>", "list references" },
        i = { "<cmd>Telescope lsp_implementations<CR>", "list implementations" },
        t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "show type definition" },
        s = { "<cmd>Telescope lsp_document_symbols<CR>", "show document symbols" },
        S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "show dynamic workspace symbols" },
        R = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename symbol" },
        f = { "<cmd>gf<CR>", "goto file" },
        F = { "<cmd>gF<CR>", "goto file (with line number)" },
        l = { "<cmd>Trouble lsp_document_diagnostics<CR>", "show document diagnostics" },
        L = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "show workspace diagnostics" },
        K = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "show line diagnostics" },
        q = { "<cmd>lua require('plugins.telescope').code_action()<CR>", "code actions" },
        Q = { "<cmd>Telescope lsp_range_code_actions<CR>", "code actions (range)" },
      },
      f = {
        name = "+find",
        b = { "<cmd>Telescope buffers<CR>", "search buffers" },
        c = { "<cmd>lua require'plugins.telescope'.dotconfig()<CR>", "search config" },
        e = { "<cmd>lua require'plugins.telescope'.explorer()<CR>", "file explorer" },
        f = { "<cmd>lua require'plugins.telescope'.file_search(false)<CR>", "find files" },
        h = { "<cmd>Telescope help_tags<CR>", "help" },
        H = { "<cmd>Telescope vim_options<CR>", "vim options" },
        o = { "<cmd>Telescope oldfiles<CR>", "old files" },
        g = { "<cmd>Telescope live_grep<CR>", "live grep" },
        r = { "<cmd>Telescope registers<CR>", "registers" }, -- could be "
        t = { "<cmd>Telescope colorscheme<CR>", "theme" },
        m = { "<cmd>Telescope man_pages<CR>", "search manual" },
        s = { "<cmd>Telescope spell_suggest<CR>", "spelling" },
        k = { "<cmd>Telescope keymaps<CR>", "find keymaps" },
        q = { "<cmd>TodoTrouble<CR>", "find notes" },
        ["/"] = { "<cmd>Telescope search_history<CR>", "search history" },
        [";"] = { "<cmd>Telescope command_history<CR>", "command history" },
        -- TODO: grep_string
      },
      -- TODO: set up g for Telescope git_*
      g = {
        name = "+git",
        [";"] = { "git blame toggle" },
        g = { "<cmd>FloatermNew lazygit<CR>", "lazygit" },
        h = { "git stage hunk" },
        r = { "git reset hunk" },
        R = { "git reset buffer" },
        d = { "git diff preview" },
        u = { "git stage hunk undo" },
        s = { "<cmd>Telescope git_stash<CR>", "git stash" },
        b = { "<cmd>Telescope git_branches<CR>", "git branches" },
        c = { "<cmd>Telescope git_bcommits<CR>", "git commits (buffer)" },
        C = { "<cmd>Telescope git_commits<CR>", "git commits (repo)" },
        y = { "git yank reference url" },
        Y = { "<cmd>lua require'gitlinker'.get_repo_url()<CR>", "git yank repo url" },
        w = {
          "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
          "git browse reference url",
        },
        W = {
          "<cmd>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
          "git browse repo url",
        },
        ["?"] = { "<cmd>Telescope git_status<CR>", "git status" },
      },
      h = {
        name = "+hop",
        c = { "<cmd>:HopChar1<CR>", "char 1" },
        C = { "<cmd>:HopChar2<CR>", "Char 2" },
        w = { "<cmd>:HopWord<CR>", "word" },
        l = { "<cmd>:HopLine<CR>", "line" },
        h = { "<cmd>:HopPattern<CR>", "pattern" },
      },
      r = {
        n = { "<cmd>lua vim.lsp.buf.rename()<CR>", "rename symbol" },
        r = { "<cmd>FloatermNew lazydocker<CR>", "lazydocker" },
      },
      s = { "<cmd>Dashboard<CR>", "Dashboard" },
      z = { "<cmd>ZenMode<CR>", "Zen Mode" },
      O = { "O<Esc>", "Create new line above" },
      o = { "o<Esc>", "Create new line below" },
      ["?"] = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    },
    ["["] = {
      name = "+previous",
      g = { "Previous git hunk" },
      d = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Previous diagnostic" },
      t = { "<cmd>call ultest#positions#prev()<CR>", "Previous test" },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Next diagnostic" },
      t = { "<cmd>call ultest#positions#next()<CR>", "Next test" },
    },
    g = {
      name = "+g",
      K = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show line diagnostics" },
      l = { "<cmd>Trouble lsp_document_diagnostics<CR>", "Show document diagnostics" },
      L = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Show workspace diagnostics" },
      q = { "<cmd>lua require('plugins.telescope').code_action()<CR>", "Code actions" },
      d = { "<cmd>Telescope lsp_definitions<CR>" },
      D = { "<cmd>lua vim.lsp.buf.declaration()<CR>" },
      r = { "<cmd>Telescope lsp_references<CR>" },
      i = { "<cmd>Telescope lsp_implementations<CR>" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
      s = { "<cmd>Telescope lsp_document_symbols<CR>" },
      S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
      -- S = { "<cmd>Telescope lsp_workspace_symbols<CR>" },
    },
  })
end

return M
