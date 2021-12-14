-- https://github.com/jose-elias-alvarez/null-ls.nvim --
local M = {}

-- Returns a table with keys of unique filetypes for null=ls formatting sources
function M.formatting_filetypes()
  local result = {}
  local sources = M.formatting_sources()
  for _, source in ipairs(sources) do
    local filetypes = source.filetypes
    for _, filetype in ipairs(filetypes) do
      result[filetype] = true
    end
  end
  return result
end

-- Use null-ls formatting if any of the given filetypes is supported
-- @param ls_filetypes of language server to be checked
function M.use_null_formatting()
  return M.formatting_filetypes()[vim.bo.filetype] ~= nil
end

function M.formatting_sources()
  local null_ls = require("null-ls")
  return {
    -- LUA: sudo pacman -S stylua
    null_ls.builtins.formatting.stylua,
    -- PYTHON: pip install black
    null_ls.builtins.formatting.black,
    -- HASKELL: yay -S brittany
    null_ls.builtins.formatting.brittany,
    -- C*: yarn global add clang_format
    null_ls.builtins.formatting.clang_format.with({
      -- NOTE: disabled_filetypes still in this.filetypes
      disabled_filtypes = { "java" },
    }),
    -- MAKE: pip install cmakelang (~/.local/bin/cmake-format)
    null_ls.builtins.formatting.cmake_format.with({
      filetypes = { "cmake", "make" }, -- TODO: check if this is necessary
    }),
    -- PRETTIER: yarn global add @fsouza/prettierd
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {
        -- null_ls.builtins.formatting.prettierd.filetypes
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "yaml",
        "markdown",
        "graphql",
        -- https://prettier.io/docs/en/plugins.html#official-plugins
        "php",
        "pug",
        "ruby",
        "xml",
        -- https://prettier.io/docs/en/plugins.html#community-plugins
        "apex", -- yarn global add prettier-plugin-apex
        "elm", -- yarn global add prettier-plugin-elm
        "java", -- yarn global add prettier-plugin-java
        "sol", -- yarn global add prettier-plugin-solidity
        "toml", -- yarn global add prettier-plugin-toml
        "svelte", -- yarn global add prettier-plugin-svelte
        "kotlin", -- yarn global add prettier-plugin-kotlin
        "sh", -- yarn global add prettier-plugin-sh
        "dockerfile",
        "jproperties",
        "conf",
        "zsh",
        "gitignore",
      },
    }),
    -- DEFAULT
    null_ls.builtins.formatting.trim_whitespace,
  }
end

function M.diagnostic_sources()
  local null_ls = require("null-ls")
  return {
    -- PYTHON: pip install pylint
    null_ls.builtins.diagnostics.pylint,
    -- LUA: cargo install selene
    null_ls.builtins.diagnostics.selene.with({
      extra_args = { "--config", vim.fn.expand("~/.config/selene.toml") },
    }),
    -- GCC: yay -S gccdiag
    -- null_ls.builtins.diagnostics.gccdiag,
    -- SH: sudo pacman -S shellcheck
    -- null_ls.builtins.diagnostics.shellcheck, -- also code_actions
  }
end

function M.code_action_sources()
  local null_ls = require("null-ls")
  return {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring,
  }
end

function M.hover_sources()
  local null_ls = require("null-ls")
  return {
    null_ls.builtins.hover.dictionary,
  }
end

function M.setup()
  -- Combine sources
  local sources = require("utils").list_flatten_once({
    require("lsp.null").formatting_sources(),
    require("lsp.null").diagnostic_sources(),
    require("lsp.null").code_action_sources(),
    require("lsp.null").hover_sources(),
  })

  -- Setup null-ls
  require("null-ls").setup({
    sources = sources,
    on_attach = require("lsp.install").default_on_attach,
  })
end

return M
