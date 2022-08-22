local M = {}

M.ensure_installed = {
  "bash",
  "c",
  "comment",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gomod",
  "hcl",
  "help",
  "html",
  "http",
  "java",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "proto",
  "python",
  "org",
  "query",
  "sql",
  "typescript",
  "tsx",
  "vim",
  "yaml",
}

-- TODO: extract requires to pcall here
-- NOTE: not sure if this works https://www.reddit.com/r/neovim/comments/rmgxkf/better_treesitter_way_to_jump_to_parentsibling/

function M.goto_parent()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  local parent = node:parent()
  ts_utils.goto_node(parent)
end

function M.goto_child()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  local child = node:child(0)
  ts_utils.goto_node(child)
end

function M.goto_prev_sibling()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  local prev_sibling = node:prev_sibling()
  ts_utils.goto_node(prev_sibling)
end

function M.goto_next_sibling()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  local next_sibling = node:next_sibling()
  ts_utils.goto_node(next_sibling)
end

M.run = ":TSUpdate"

function M.setup()
  local this = require("axie.plugins.treesitter")
  vim.keymap.set("n", ",[", this.goto_prev_sibling, { desc = "goto previous sibling node" })
  vim.keymap.set("n", ",]", this.goto_next_sibling, { desc = "goto next sibling node" })
  vim.keymap.set("n", ",{", this.goto_parent, { desc = "goto parent node" })
  vim.keymap.set("n", ",}", this.goto_child, { desc = "goto child node" })
end

function M.config()
  local vim_apply = require("axie.utils").vim_apply

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

  local ensure_installed = require("axie.plugins.treesitter").ensure_installed
  vim.list_extend(ensure_installed, { "org" })

  require("nvim-treesitter.configs").setup({
    -- Treesitter
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = {
      enable = true,
      disable = { "org" },
      additional_vim_regex_highlighting = { "org" },
    },
    indent = {
      indent = true,
      disable = { "python" },
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
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["gp"] = "@function.outer",
          ["<space>lp"] = "@function.outer",
          ["gP"] = "@class.outer",
          ["<space>lP"] = "@class.outer",
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

    -- Matching Text Navigation
    -- https://github.com/andymass/vim-matchup
    matchup = {
      enable = true,
      disable_virtual_text = true, -- using nvim-biscuits instead
      -- include_match_words = true,
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

  -- TEMP: bash parser for zsh https://github.com/nvim-treesitter/nvim-treesitter/issues/655
  local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
  require("nvim-treesitter.parsers").ft_to_lang = function(ft)
    if ft == "zsh" then
      return "bash"
    end
    return ft_to_lang(ft)
  end
end

return M
