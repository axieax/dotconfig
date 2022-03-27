-- https://github.com/nvim-neo-tree/neo-tree.nvim/
-- TODO: file nesting?
-- TODO: bindings for alt sources?
-- TODO: vim.ui.input
-- TODO: group empty
-- TODO: highlight open buffers?
-- TODO: remove nvimtree

return function()
  -- Unless you are still migrating, remove the deprecated commands from v1.x
  vim.g.neo_tree_remove_legacy_commands = 1
  require("neo-tree").setup({
    default_component_configs = {
      indent_size = 1,
      name = {
        trailing_slash = true,
      },
    },
    window = {
      position = "right",
      width = "30%",
    },
    filesystem = {
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        never_show = { ".git" },
      },
    },
  })
end
