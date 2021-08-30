-- https://github.com/mhartington/formatter.nvim --
-- SETUP: add (yarn global bin) to path

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
      -- general remove whitespace
      javascript = { prettier },
      typescript = { prettier },
      javascriptreact = { prettier },
      typescriptreact = { prettier },
      flow = { prettier },
      json = { prettier },
      html = { prettier },
      vue = { prettier },
      angular = { prettier },
      ember = { prettier },
      css = { prettier },
      less = { prettier },
      scss = { prettier },
      graphql = { prettier },
      markdown = { prettier },
      yaml = { prettier },
      lua = { stylua },
      c = { clang_format },
      cpp = { clang_format },
      python = { black },
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
