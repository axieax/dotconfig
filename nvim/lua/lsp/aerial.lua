-- https://github.com/stevearc/aerial.nvim --

return function()
  require("aerial").setup({
    -- close_behavior = "close",
    highlight_on_jump = 200,
    close_on_select = true,
    -- fold code from tree (overwrites treesitter foldexpr)
    -- manage_folds = true,
    link_tree_to_folds = true,
    link_folds_to_tree = true,
  })
end
