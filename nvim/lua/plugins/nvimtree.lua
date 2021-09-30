-- https://github.com/preservim/nerdtree --
-- NOTE: background colour?

return function()
  local utils = require("utils")

  require("nvim-tree").setup({
    -- lsp_diagnostics = true, -- colour instead of signcolumn
    view = {
      width = "30%",
      side = "right",
      auto_resize = true,
    },
  })

  utils.vim_apply(vim.g, {
    nvim_tree_indent_markers = 1,
    nvim_tree_group_empty = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_add_trailing = 1,
    nvim_tree_quit_on_open = 1,
    -- nvim_tree_side = "right",
    -- -- nvim_tree_auto_close = 1,
    -- nvim_tree_git_hl = 1,
  })

  utils.map({ "n", ";", "<cmd>NvimTreeToggle<CR>" })
end
