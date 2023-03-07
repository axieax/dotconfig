local M = {}

M.ensure_installed = {
  "stylua",
  -- formatter --
  "black",
  "isort",
  -- "goimports",
  "prettierd",
  "shfmt",
  -- "google-java-format",
  -- linter --
  -- "selene",
  "editorconfig-checker",
  -- "golangci-lint",
  "pylint",
  "shellcheck",
}

-- Use null-ls formatting if any of the given filetypes is supported
-- @param ls_filetypes of language server to be checked
function M.use_null_formatting(filetype)
  local null_ls = require("null-ls")
  local null_ls_sources = require("null-ls.sources")

  local sources = null_ls_sources.get_available(filetype, null_ls.methods.FORMATTING)
  for _, source in ipairs(sources) do
    if source.name ~= "trim_whitespace" then
      local cmd = source.generator.opts.command
      if vim.fn.executable(cmd) == 1 then
        -- require("axie.utils").notify(string.format("%s using null-ls formatting with %s", filetype, source.name))
        return true
      end
    end
  end
  return false
end

function M.formatting_sources()
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting
  return {
    -- NOTE: sumneko_lua has builtin EmmyLuaCodeStyle support
    formatting.stylua, -- lua
    formatting.black, -- python
    formatting.isort, -- python
    -- NOTE: this superset of gofmt is preferred if installed
    formatting.goimports, -- go
    formatting.brittany, -- haskell (yay -S brittany)
    formatting.clang_format.with({ disabled_filetypes = { "java" } }), -- c*
    -- make: pip install cmakelang (~/.local/bin/cmake-format)
    formatting.cmake_format.with({
      filetypes = { "cmake", "make" }, -- TODO: check if this is necessary
    }),
    formatting.google_java_format, -- java
    -- prettier: npm install -g @fsouza/prettierd
    formatting.prettierd.with({
      extra_filetypes = {
        -- https://prettier.io/docs/en/plugins.html#official-plugins
        "php",
        "pug",
        "ruby",
        "xml",
        -- https://prettier.io/docs/en/plugins.html#community-plugins
        "apex", -- npm install -g prettier-plugin-apex
        "elm", -- npm install -g prettier-plugin-elm
        -- "java", -- npm install -g prettier-plugin-java
        "sol", -- npm install -g prettier-plugin-solidity
        "toml", -- npm install -g prettier-plugin-toml
        "svelte", -- npm install -g prettier-plugin-svelte
        "kotlin", -- npm install -g prettier-plugin-kotlin
        "sh", -- npm install -g prettier-plugin-sh
        "dockerfile",
        "jproperties",
        "conf",
        "zsh", -- https://github.com/mvdan/sh/issues/120
        "gitignore",
      },
    }),
    -- bazel: go install github.com/bazelbuild/buildtools/buildifier@latest or yay -S bazel-buildtools
    formatting.buildifier,
    -- default: pip install codespell
    -- ISSUE: false positives (e.g. ans -> and) may cause compilation problems
    -- formatting.codespell,
    -- formatting.buf, -- protobuf (yay -S buf)
    formatting.trim_whitespace, -- default
  }
end

function M.diagnostic_sources()
  local null_ls = require("null-ls")
  local diagnostics = null_ls.builtins.diagnostics
  return {
    diagnostics.pylint, -- python
    -- lua
    diagnostics.selene.with({
      extra_args = { "--config", vim.fn.expand("~/.config/selene.toml") },
      condition = function(utils)
        return utils.root_has_file({ "selene.toml" })
      end,
    }),
    diagnostics.cppcheck, -- c/c++ (sudo pacman -S cppcheck)
    -- gcc: yay -S gccdiag or compile from source
    diagnostics.gccdiag.with({
      condition = function(utils)
        return utils.root_has_file({ "compile_commands.json" })
      end,
    }),
    -- TODO: override diagnostic format?
    diagnostics.shellcheck, -- sh
    -- default
    diagnostics.editorconfig_checker.with({
      condition = function(utils)
        return utils.root_has_file({ ".editorconfig" })
      end,
    }),
    -- diagnostics.buf, -- protobuf
    -- diagnostics.trail_space, -- default
  }
end

function M.code_action_sources()
  local null_ls = require("null-ls")
  local code_actions = null_ls.builtins.code_actions
  return {
    code_actions.shellcheck, -- sh
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

function M.config()
  -- Combine sources
  local sources = require("axie.utils").list_flatten_once({
    require("axie.plugins.lsp.null").formatting_sources(),
    require("axie.plugins.lsp.null").diagnostic_sources(),
    require("axie.plugins.lsp.null").code_action_sources(),
    require("axie.plugins.lsp.null").hover_sources(),
  })

  -- Setup null-ls
  require("null-ls").setup({
    sources = sources,
    on_attach = require("axie.plugins.lsp.options").default_on_attach,
    -- debug = true,
  })
end

return M
