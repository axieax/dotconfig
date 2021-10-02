-- https://github.com/mhartington/formatter.nvim --
-- SETUP: add (yarn global bin) to path
-- yarn global or project dev dependency
-- NOTE: suggested formatters - https://github.com/sbdchd/neoformat#supported-filetypes

return function()
  local function prettier()
    -- INSTALL: yarn global add prettier
    -- PLUGINS:
    -- prettier-plugin-sh prettier-plugin-java prettier-plugin-toml
    -- prettier-plugin-apex prettier-plugin-elm prettier-plugin-svelte prettier-plugin-kotlin
    -- @prettier/plugin-php @prettier/plugin-ruby @prettier/plugin-xml @prettier/plugin-pug
    return {
      exe = "prettier",
      args = {
        "--stdin-filepath",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
      },
      stdin = true,
    }
  end

  local function eslint_d()
    -- INSTALL: yarn global add eslint_d
    return {
      exe = "eslint_d",
      args = {
        "--stdin",
        "--stdin-filename",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
        "--fix-to-stdout",
      },
      stdin = true,
    }
  end

  local function stylua()
    -- INSTALL: sudo pacman -S stylua
    return {
      exe = "stylua",
      args = {
        "--stdin-filepath",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
        "--search-parent-directories",
        "-",
      },
      stdin = true,
    }
  end

  local function clang_format()
    -- INSTALL: yarn global add clang_format
    return {
      exe = "clang-format",
      args = {
        "--assume-filename",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
      },
      stdin = true,
      cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
    }
  end

  local function black()
    -- INSTALL: pip install black
    return {
      exe = "python -m black",
      args = {
        "--stdin-filename",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
        "-",
      },
      stdin = true,
    }
  end

  local function brittany()
    -- INSTALL: sudo pacman -S haskell-brittany
    return {
      exe = "brittany",
      stdin = true,
    }
  end

  local function gofmt()
    return {
      exe = "gofmt",
      stdin = true,
    }
  end

  local function rustfmt()
    return {
      exe = "rustfmt",
      args = { "--emit=stdout" },
      stdin = true,
    }
  end

  local function cmake_format()
    -- INSTALL: pip install cmakelang
    return {
      exe = "cmake-format", -- ~/.local/bin/cmake-format
      args = { "-" },
      stdin = true,
    }
  end

  local function google_java_format()
    -- INSTALL: yay google-java-format
    return {
      exe = "google-java-format",
      args = {
        "--assume-filename",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
        "-",
      },
      stdin = true,
    }
  end

  -- NOTE: keys refer to vim.bo.filetype
  require("formatter").setup({
    logging = false,
    filetype = {
      ["*"] = {},
      -- general remove whitespace
      javascript = { prettier, eslint_d },
      typescript = { prettier, eslint_d },
      javascriptreact = { prettier, eslint_d },
      typescriptreact = { prettier, eslint_d },
      json = { prettier },
      -- json = { clang_format }, -- NOTE: fallback
      html = { prettier },
      css = { prettier },
      less = { prettier },
      scss = { prettier },
      graphql = { prettier },
      markdown = { prettier },
      yaml = { prettier },
      lua = { stylua },
      c = { clang_format },
      cs = { clang_format },
      cpp = { clang_format },
      objc = { clang_format }, -- TODO: check if this is the correct ft
      proto = { clang_format },
      -- TODO: csv? erlang? matlab? pandoc for pandoc markdown? R? sass? latex?
      python = { black },
      go = { gofmt },
      rust = { rustfmt },
      apex = { prettier },
      elm = { prettier },
      java = { prettier },
      -- java = { google_java_format }, -- NOTE: alternative
      -- java = { clang_format }, -- NOTE: fallback
      php = { prettier },
      ruby = { prettier },
      toml = { prettier },
      xml = { prettier },
      svelte = { prettier },
      kotlin = { prettier },
      pug = { prettier },
      haskell = { brittany },
      sh = { prettier },
      dockerfile = { prettier },
      jproperties = { prettier },
      conf = { prettier },
      zsh = { prettier },
      [""] = { prettier }, -- .gitignore
      make = { cmake_format },
      txt = {},
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
  -- Save without formatting
  vim.cmd("command! W :noautocmd w")
  vim.cmd("command! Wq :noautocmd wq")
end
