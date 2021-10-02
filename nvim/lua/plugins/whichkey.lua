-- https://github.com/folke/which-key.nvim --

return function()
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
        -- TODO
      },
      t = {
        name = "+test",
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
        b = { "search buffers" },
        c = { "search config" },
        e = { "file explorer" },
        f = { "find files" },
        h = { "help" },
        H = { "vim options" },
        o = { "old files" },
        g = { "live grep" },
        r = { "registers" },
        t = { "theme" },
        m = { "search manual" },
        s = { "spelling" },
        k = { "find keymaps" },
        q = { "find notes" },
        ["/"] = { "search history" },
        [";"] = { "command history" },
        -- TODO: grep_string
      },
      -- TODO: set up g for Telescope git_*
      g = {
        name = "+git",
        [";"] = { "git blame toggle" },
        g = { "<cmd>:FloatermNew lazygit<CR>", "lazygit" },
        h = { "git stage hunk" },
        r = { "git reset hunk" },
        R = { "git reset buffer" },
        d = { "git diff preview" },
        u = { "git stage hunk undo" },
        s = { "git stash" },
        b = { "git branches" },
        c = { "git buffer commits" },
        C = { "git repo commits" },
        y = { "git yank reference url" },
        Y = { "git yank repo url" },
        w = { "git browse reference url" },
        W = { "git browse repo url" },
        ["?"] = { "git status" },
      },
      h = {
        name = "+hop",
        c = { "<cmd>:HopChar1<CR>", "char 1" },
        C = { "<cmd>:HopChar2<CR>", "Char 2" },
        w = { "<cmd>:HopWord<CR>", "word" },
        l = { "<cmd>:HopLine<CR>", "line" },
        h = { "<cmd>:HopPattern<CR>", "pattern" },
      },
    },
    ["["] = {
      name = "+previous",
      g = { "Previous git hunk" },
      d = { "Previous diagnostic" },
      t = { "Previous test" },
    },
    ["]"] = {
      name = "+next",
      g = { "Next git hunk" },
      d = { "Next diagnostic" },
      t = { "Next test" },
    },
  })
end
