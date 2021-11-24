-- https://github.com/nvim-treesitter/nvim-treesitter --
-- https://github.com/nvim-treesitter/playground --
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects --

return function()
  local vim_apply = require("utils").vim_apply
  require("nvim-treesitter.configs").setup({
    -- Treesitter
    -- ensure_installed = require("utils.config").prepared_parsers,
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
        init_selection = ",,",
        scope_incremental = ",,",
        node_incremental = ",m",
        node_decremental = ",n",
      },
    },
    -- Autotags
    autotag = {
      enable = true,
      -- https://github.com/windwp/nvim-ts-autotag#default-values
      -- NOTE: markdown doesn't have a TS parser
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
      move = {
        enable = true,
        set_jumps = true,
        goto_previous_start = {
          -- ["[["] = "@parameter.inner",
        },
        goto_next_start = {
          -- ["]]"] = "@parameter.inner",
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
    -- Comment string
    context_commentstring = {
      enable = true,
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

  -- select previous / next parameter
  -- NOTE: also in after/ftplugin/python.vim due to default ftplugin overriding
  local map = require("utils").map
  -- map({ "n", "[[", "[[viq", noremap = false })
  -- map({ "n", "]]", "]]viq", noremap = false })
  map({
    "n",
    "[[",
    ":lua require'nvim-treesitter.textobjects.move'.goto_previous_end('@parameter.inner')<CR>viq",
    noremap = false,
    buffer = true,
  })
  map({
    "v",
    "[[",
    "<esc>:lua require'nvim-treesitter.textobjects.move'.goto_previous_end('@parameter.inner')<CR>viq",
    noremap = false,
    buffer = true,
  })
  map({
    "n",
    "]]",
    ":lua require'nvim-treesitter.textobjects.move'.goto_next_start('@parameter.inner')<CR>viq",
    noremap = false,
    buffer = true,
  })
  map({
    "v",
    "]]",
    "<esc>:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@parameter.inner')<CR>viq",
    noremap = false,
    buffer = true,
  })
end
