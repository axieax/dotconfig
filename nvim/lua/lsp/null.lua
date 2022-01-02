-- https://github.com/jose-elias-alvarez/null-ls.nvim --
local M = {}

-- Use null-ls formatting if any of the given filetypes is supported
-- @param ls_filetypes of language server to be checked
function M.use_null_formatting(filetype)
  local null_ls = require("null-ls")
  local null_ls_sources = require("null-ls.sources")

  local sources = null_ls_sources.get({})
  for _, source in ipairs(sources) do
    if
      source.name ~= "trim_whitespace"
      and null_ls_sources.is_available(source, filetype, null_ls.methods.FORMATTING)
    then
      return true
    end
  end
  return false
end

function M.formatting_sources()
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting
  return {
    -- LUA: sudo pacman -S stylua
    formatting.stylua,
    -- PYTHON: pip install black
    formatting.black,
    -- PYTHON: pip install isort (import sort)
    formatting.isort,
    -- HASKELL: yay -S brittany
    formatting.brittany,
    -- C*: yarn global add clang_format
    formatting.clang_format.with({
      -- NOTE: disabled_filetypes still in this.filetypes
      disabled_filtypes = { "java" },
    }),
    -- MAKE: pip install cmakelang (~/.local/bin/cmake-format)
    formatting.cmake_format.with({
      filetypes = { "cmake", "make" }, -- TODO: check if this is necessary
    }),
    -- PRETTIER: yarn global add @fsouza/prettierd
    formatting.prettierd.with({
      filetypes = {
        -- formatting.prettierd.filetypes
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
    -- DEFAULT: pip install codespell
    formatting.codespell,
    -- DEFAULT
    formatting.trim_whitespace,
  }
end

function M.diagnostic_sources()
  local null_ls = require("null-ls")
  local diagnostics = null_ls.builtins.diagnostics
  return {
    -- PYTHON: pip install pylint
    diagnostics.pylint,
    -- LUA: cargo install selene
    diagnostics.selene.with({
      extra_args = { "--config", vim.fn.expand("~/.config/selene.toml") },
      condition = function(utils)
        return utils.root_has_file({ "selene.toml" })
      end,
    }),
    -- GCC: yay -S gccdiag
    -- diagnostics.gccdiag,
    -- SH: sudo pacman -S shellcheck
    -- diagnostics.shellcheck, -- also code_actions
  }
end

function M.code_action_sources()
  local null_ls = require("null-ls")
  local code_actions = null_ls.builtins.code_actions
  return {
    code_actions.gitsigns,
    code_actions.refactoring,
  }
end

function M.hover_sources()
  local null_ls = require("null-ls")
  local hover = null_ls.builtins.hover
  return {
    hover.dictionary,
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
