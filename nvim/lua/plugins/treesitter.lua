-- https://github.com/nvim-treesitter/nvim-treesitter --
-- https://github.com/nvim-treesitter/playground --
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects --

return function()
  local vim_apply = require("utils").vim_apply
  require("nvim-treesitter.configs").setup({
    -- Treesitter
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      indent = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gs",
        node_incremental = "gm",
        node_decremental = "gn",
        scope_incremental = "gs",
      },
    },
    -- Autotags
    autotag = {
      enable = true,
      -- https://github.com/windwp/nvim-ts-autotag#default-values
      -- filetypes = {
      --   "html",
      --   "javascript",
      --   "javascriptreact",
      --   "typescriptreact",
      --   "svelte",
      --   "vue",
      --   "markdown",
      --   "md",
      -- },
    },
    -- Playground
    playground = {
      enable = true,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      -- lint_events = {"BuffWrite", "CursorHold"},
    },
    -- Textobjects
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["ai"] = "@conditional.outer",
          ["iq"] = "@conditional.inner",
          ["cq"] = "@comment.outer",
        },
      },
    },
  })

  -- Folding (zopen/zclose, zReveal/zMinimise)
  -- TODO: use TS query to find all functions/methods - vifzc, repeat with classes, then zR
  vim_apply(vim.o, {
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    foldnestmax = 3, -- maximum nesting of folds
    -- foldminlines = 1, -- min lines required for a fold (default)
    foldlevel = 0, -- default levels folded
    foldenable = false, -- don't fold by default
  })
end
