local M = {}

M.dev_mode = false
M.nvchad_theme = true

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
