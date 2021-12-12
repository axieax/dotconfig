-- https://github.com/jose-elias-alvarez/null-ls.nvim --
local M = {}

function M.formatting_sources()
  local null_ls = require("null-ls")
  return {
    -- LUA: sudo pacman -S stylua
    null_ls.builtins.formatting.stylua,
    -- PYTHON: pip install black
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.brittany,
    -- C*: yarn global add clang_format
    null_ls.builtins.formatting.clang_format.with({
      disabled_filtypes = { "java" },
    }),
    -- MAKE: pip install cmakelang (~/.local/bin/cmake-format)
    null_ls.builtins.formatting.cmake_format.with({
      filetypes = { "cmake", "make" }, -- TODO: check if this is necessary
    }),
    -- PRETTIER: yarn global add @fsouza/prettierd
    null_ls.builtins.formatting.prettierd.with({
      -- TODO: filetypes all?
      filetypes = {
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
    -- GCC: yay -S gccdiag
    null_ls.builtins.diagnostics.gccdiag,
    -- ESLINT: yarn global add eslint_d
    null_ls.builtins.diagnostics.eslint_d,
  }
end

function M.code_action_sources()
  local null_ls = require("null-ls")
  return {
    null_ls.builtins.code_actions.gitsigns,
  }
end

function M.setup()
  local sources = {}
  local types = {
    require("lsp.null").formatting_sources(),
    require("lsp.null").diagnostic_sources(),
    require("lsp.null").code_action_sources(),
  }
  for _, type in ipairs(types) do
    for _, source in ipairs(type) do
      table.insert(sources, source)
    end
  end
  require("null-ls").config({ sources = sources })
  require("lspconfig")["null-ls"].setup({
    on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
      end
    end,
  })
end

return M
