-- https://github.com/kyazdani42/nvim-tree.lua --
-- ctrl-k to view file info

return function()
  local utils = require("axie.utils")

  -- TODO: setup migration https://github.com/kyazdani42/nvim-tree.lua/issues/674
  utils.vim_apply(vim.g, {
    nvim_tree_git_hl = 1,
    nvim_tree_indent_markers = 1,
    nvim_tree_group_empty = 1,
    nvim_tree_highlight_opened_files = 1,
    nvim_tree_add_trailing = 1,
  })

  require("nvim-tree").setup({
    -- auto_close = true,
    disable_netrw = false,
    hijack_netrw = true,
    -- hijack_unnamed_buffer_when_opening = true,
    -- lsp_diagnostics = true, -- prefer colour instead of signcolumn
    update_to_buf_dir = {
      -- hijacks new directory buffers when they are opened
      enable = true,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
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
end
