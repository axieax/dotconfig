local M = {}

M.cmd = {
  "TSInstall",
  "TSInstallFromGrammar",
  "TSInstallSync",
  "TSInstallUpdate",
  "TSInstallUpdateSync",
  "TSInstallUninstall",
  "TSInstallInfo",
  "TSModuleInfo",
  "TSBufEnable",
  "TSBufDisable",
  "TSBufToggle",
  "TSEnable",
  "TSDisable",
  "TSToggle",
  "TSConfigInfo",
  "TSEditQuery",
  "TSEditQueryUserAfter",
}

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
  "vimdoc",
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

function M.init()
  local this = require("axie.plugins.editor.treesitter")
  vim.keymap.set("n", ",[", this.goto_prev_sibling, { desc = "Goto previous sibling node" })
  vim.keymap.set("n", ",]", this.goto_next_sibling, { desc = "Goto next sibling node" })
  vim.keymap.set("n", ",{", this.goto_parent, { desc = "Goto parent node" })
  vim.keymap.set("n", ",}", this.goto_child, { desc = "Goto child node" })
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

  local ensure_installed = require("axie.plugins.editor.treesitter").ensure_installed
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

    query_linter = {
      enable = true,
      use_virtual_text = true,
      -- lint_events = {"BuffWrite", "CursorHold"},
    },

    -- Text Objects
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
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
      swap = {
        enable = true,
        swap_next = {
          [",a"] = "@parameter.inner",
        },
        swap_previous = {
          [",x"] = "@parameter.inner",
        },
      },
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
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["gp"] = "@function.outer",
          ["<Space>lp"] = "@function.outer",
          ["gP"] = "@class.outer",
          ["<Space>lP"] = "@class.outer",
        },
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

    -- Matching Text Navigation
    -- https://github.com/andymass/vim-matchup
    matchup = {
      enable = true,
      disable_virtual_text = true, -- using nvim-biscuits instead
      -- include_match_words = true,
    },
  })

  -- Folding
  -- TODO: use TS query to find all functions/methods - vifzc, repeat with classes, then zR
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  -- TEMP: bash parser for zsh https://github.com/nvim-treesitter/nvim-treesitter/issues/655
  vim.treesitter.language.register("bash", "zsh")
  vim.treesitter.language.register("terraform", "terraform-vars")
end

return M
