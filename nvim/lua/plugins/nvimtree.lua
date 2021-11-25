-- https://github.com/preservim/nerdtree --
-- NOTE: background colour?

return function()
  local utils = require("utils")

  require("nvim-tree").setup({
    disable_netrw = false,
    hijack_netrw = true,
    -- lsp_diagnostics = true, -- prefer colour instead of signcolumn
    update_to_buf_dir = {
      -- hijacks new directory buffers when they are opened
      enable = true,
    },
    view = {
      width = "30%",
      side = "right",
      auto_resize = true,
    },
    filters = {
      custom = { ".git" },
    },
  })

  utils.vim_apply(vim.g, {
    nvim_tree_indent_markers = 1,
    nvim_tree_group_empty = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_add_trailing = 1,
    nvim_tree_quit_on_open = 1,
    -- nvim_tree_side = "right",
    -- nvim_tree_auto_close = 1,
    -- nvim_tree_git_hl = 1,
  })
end
