-- https://github.com/nvim-treesitter/nvim-treesitter --

return function()
  local vim_apply = require("utils").vim_apply

  -- Orgmode.nvim integration
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.org = {
    install_info = {
      url = "https://github.com/milisims/tree-sitter-org",
      revision = "f110024d539e676f25b72b7c80b0fd43c34264ef",
      files = { "src/parser.c", "src/scanner.cc" },
    },
    filetype = "org",
  }

  local ensure_installed = require("nvim-treesitter.parsers").available_parsers()
  vim.list_extend(ensure_installed, {
    "org",
  })

  require("nvim-treesitter.configs").setup({
    -- Treesitter
    -- ensure_installed = require("utils.config").prepared_parsers,
    ensure_installed = ensure_installed,
    highlight = {
      enable = true,
      disable = { "org" },
      additional_vim_regex_highlighting = { "org" },
    },
    indent = {
      indent = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = ",,",
        scope_incremental = ",,",
        node_incremental = ",m",
        node_decremental = ",n",
      },
    },

    -- Playground
    -- https://github.com/nvim-treesitter/playground
    playground = {
      enable = true,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      -- lint_events = {"BuffWrite", "CursorHold"},
    },

    -- Text Objects
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
      move = {
        enable = true,
        set_jumps = true,
        goto_previous_start = {
          ["[["] = "@parameter.inner",
        },
        goto_next_start = {
          ["]]"] = "@parameter.inner",
        },
      },
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["if"] = "@function.inner",
          ["af"] = "@function.outer",
          ["ic"] = "@class.inner",
          ["ac"] = "@class.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
          ["ii"] = "@conditional.inner",
          ["ai"] = "@conditional.outer",
          ["iq"] = "@parameter.inner",
          ["aq"] = "@parameter.outer",
          ["ag"] = "@comment.outer",
        },
      },
    },

    -- Text Subjects
    -- https://github.com/RRethy/nvim-treesitter-textsubjects
    textsubjects = {
      enable = true,
      keymaps = {
        ["<CR>"] = "textsubjects-smart",
        ["<S-CR>"] = "textsubjects-container-outer",
      },
    },

    -- Autotags
    -- https://github.com/windwp/nvim-ts-autotag
    autotag = {
      enable = true,
    },

    -- Coloured Brackets
    -- https://github.com/p00f/nvim-ts-rainbow
    rainbow = {
      enable = true,
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags
      max_file_lines = 1000,
    },

    -- Comment String
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    context_commentstring = {
      enable = true,
      enable_autocmd = false, -- for Comment.nvim integration
    },
  })

  -- Folding (zopen/zclose, zReveal/zMinimise)
  -- TODO: use TS query to find all functions/methods - vifzc, repeat with classes, then zR
  vim_apply(vim.o, {
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    -- foldnestmax = 3, -- maximum nesting of folds
    -- foldminlines = 1, -- min lines required for a fold (default)
    foldlevel = 0, -- default levels folded
    foldenable = false, -- don't fold by default
  })
end
