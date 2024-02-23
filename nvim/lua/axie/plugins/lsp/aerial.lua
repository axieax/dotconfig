local M = {}

M.keys = {
  { "<Space><Tab>", "<Cmd>AerialToggle<CR>", desc = "Aerial symbols" },
  { "\\<Tab>", "<Cmd>AerialNavToggle<CR>", desc = "Aerial nav" },
}

function M.config()
  local aerial = require("aerial")
  aerial.setup({
    -- close_behavior = "close",
    highlight_on_hover = true,
    highlight_on_jump = 200,
    close_on_select = true,
    -- fold code from tree (overwrites treesitter foldexpr)
    manage_folds = false,
    -- link_tree_to_folds = true,
    -- link_folds_to_tree = true,
    show_guides = true,
    guides = {
      mid_item = "│ ",
      last_item = "└ ",
    },
    filter_kind = false,
    icons = require("axie.utils.config").symbol_icons,
    -- fall back to treesitter if LSP not available
    backends = { "lsp", "treesitter", "markdown", "man" },
    -- jump to start of symbol name
    treesitter = { experimental_selection_range = true },
    keymaps = {
      ["<"] = {
        callback = aerial.tree_decrease_fold_level,
        desc = "Decrease the fold level of the tree",
        nowait = true,
      },
      [">"] = {
        callback = aerial.tree_increase_fold_level,
        desc = "Increase the fold level of the tree",
        nowait = true,
      },
    },
  })
end

return M
