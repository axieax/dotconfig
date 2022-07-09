local M = {}

M.dev_mode = false
M.nvchad_theme = true
M.copilot_enabled = true

M.prepared_language_servers = {
  ---------------
  -- Scripting --
  ---------------
  "pyright",
  "sumneko_lua",
  "bashls",
  ---------------------
  -- Web Development --
  ---------------------
  -- "dockerls",
  "tsserver",
  "emmet_ls",
  "jsonls",
  -- "eslint",
  -- "cssls",
  -- "html",
  -------------------
  -- Miscellaneous --
  -------------------
  -- "jdtls",
  "clangd",
  -- "cmake",
  -- "rust_analyzer",
  -- "gopls",
  -- "hls",
  -- "jdtls",
  -- "sqls",
  -- "texlab",
}

M.prepared_treesitter_parsers = {
  "bash",
  "c",
  "comment",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gomod",
  "hcl",
  "help",
  "html",
  "http",
  "java",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "proto",
  "python",
  "org",
  "query",
  "sql",
  "typescript",
  "tsx",
  "vim",
  "yaml",
}

-- Icons
M.diagnostics_icons = {
  Error = "",
  Warn = "",
  Hint = "",
  -- Hint = "",
  Info = "",
  VirtualText = "",
}

M.fileformat_icons = {
  unix = "",
  mac = "",
  dos = "",
}

return M
