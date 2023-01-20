local M = {}

function M.init()
  vim.keymap.set("n", "<Space><Tab>", "<Cmd>AerialToggle<CR>", { desc = "Aerial Symbols" })
end

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
    -- fall back to treesitter if LSP not available
    backends = { "lsp", "treesitter", "markdown", "man" },
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
