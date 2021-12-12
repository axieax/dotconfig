local M = {}

function M.prepared_language_servers()
  return {
    ---------------
    -- Scripting --
    ---------------
    "pyright",
    "sumneko_lua",
    "bashls",
    ---------------------
    -- Web Development --
    ---------------------
    "dockerls",
    "tsserver",
    "emmet_ls",
    "jsonls",
    "eslint",
    "cssls",
    "html",
    -- "tailwindcss",
    -------------------
    -- Miscellaneous --
    -------------------
    "clangd",
    "cmake",
    "rust_analyzer",
    "gopls",
    "hls",
    -- "jdtls",
    -- "sqls",
    -- "texlab",
  }
end

-- Default languages/technologies required to be setup
-- TODO: lsp install and treesitter parse
-- NOTE: other languages should be lazily installed
M.prepared_parsers = {
  ---------------
  -- Scripting --
  ---------------
  "python",
  "lua",
  "bash",
  ---------------------
  -- Web Development --
  ---------------------
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "jsdoc",
  "jsx",
  "tsx",
  "json",
  -- "json5",
  "jsonc",
  "yaml",
  "dockerfile",
  -- "php",
  -------------------
  -- Miscellaneous --
  -------------------
  "c",
  "cpp",
  "cmake",
  -- "erlang",
  "go",
  "latex",
  -- "perl",
  "java",
  "http",
  "query",
  "r",
  -- "ruby",
  "rust",
  "toml",
  "graphql",
  "haskell",
  -- "fish",
  "regex",
  "comment",
  -- "c_sharp",
}

-- Icons
M.lsp_diagnostics_icons = {
  Error = "",
  Warn = "",
  Hint = "",
  -- Hint = "",
  Info = "",
  VirtualText = "",
}

return M
