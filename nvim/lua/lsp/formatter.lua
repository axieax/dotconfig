-- https://github.com/mhartington/formatter.nvim --
-- SETUP: add (yarn global bin) to path
-- LUA: sudo pacman -S stylua
-- PRETTIER: yarn global add prettier
-- CLANG_FORMAT: yarn global add clang_format
-- PYTHON: pip install black
-- yarn global or project dev dependency
-- NOTE: suggested formatters - https://github.com/sbdchd/neoformat#supported-filetypes

return function()
  local bufname = vim.api.nvim_buf_get_name(0)

  local function prettier()
    -- INSTALL: yarn global add prettier
    return {
      exe = "prettier",
      args = { "--stdin-filepath", bufname, "--single-quote" },
      stdin = true,
    }
  end

  local function stylua()
    -- INSTALL: sudo pacman -S stylua
    return {
      exe = "stylua",
      args = {
        "--stdin-filepath",
        bufname,
        "--indent-type",
        "Spaces",
        "--indent-width",
        "2",
        "-",
      },
      stdin = true,
    }
  end

  local function clang_format()
    -- INSTALL: yarn global add clang_format
    return {
      exe = "clang-format",
      args = { "--assume-filename", bufname },
      stdin = true,
      cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
    }
  end

  local function black()
    -- INSTALL: pip install black
    return {
      exe = "python -m black",
      args = { "--stdin-filename", bufname, "-" },
      stdin = true,
    }
  end

  require("formatter").setup({
    logging = false,
    filetype = {
      ["*"] = {},
      -- general remove whitespace
      javascript = { prettier, clang_format }, -- TODO: eslint_d
      typescript = { prettier },
      javascriptreact = { prettier },
      typescriptreact = { prettier },
      json = { prettier, clang_format },
      html = { prettier },
      vue = { prettier },
      css = { prettier },
      less = { prettier },
      scss = { prettier }, -- NOTE: no sass support
      graphql = { prettier },
      markdown = { prettier },
      yaml = { prettier },
      lua = { stylua },
      c = { clang_format },
      cs = { clang_format },
      cpp = { clang_format },
      objc = { clang_format }, -- TODO: check if this is the correct ft
      proto = { clang_format },
      -- TODO: cmake? csv? go? rust? erlang? haskell? matlab? pandoc for pandoc markdown? R? sass? shell/bash (use prettier-plugin-sh)? zsh?
      python = { black },
      apex = { prettier }, -- SETUP: yarn global add prettier-plugin-apex
      elm = { prettier }, -- SETUP: yarn global add prettier-plugin-elm
      java = { prettier, clang_format }, -- SETUP: yarn global add prettier-plugin-java
      php = { prettier }, -- SETUP: yarn global add @prettier/plugin-php
      ruby = { prettier }, -- SETUP: yarn global add @prettier/plugin-ruby
      toml = { prettier }, -- SETUP: yarn global add prettier-plugin-toml
      xml = { prettier }, -- SETUP: yarn global add @prettier/plugin-xml
      svelte = { prettier }, -- SETUP: yarn global add prettier-plugin-svelte
      kotlin = { prettier }, -- SETUP: yarn global add prettier-plugin-kotlin
      -- prettier-plugin-sh for shellscript, Dockerfile, properties, gitignore, dotenv, hosts, jvmoptions...
    },
  })
  -- Format on save
  vim.api.nvim_exec(
    [[
		augroup FormatAutogroup
		autocmd!
		autocmd BufWritePost * FormatWrite
		augroup END
		]],
    true
  )
end
