-- https://github.com/nvim-neo-tree/neo-tree.nvim --
-- TODO: file nesting
-- TODO: group empty https://github.com/nvim-neo-tree/neo-tree.nvim/issues/211
-- TODO: highlight open buffers
-- TODO: remove nvimtree
-- TODO: file preview / info (size, perms, time etc.)
-- TODO: update git / diagnostic icons/colours

return function()
  require("neo-tree").setup({
    use_popups_for_input = false,
    default_component_configs = {
      indent_size = 1,
      name = {
        trailing_slash = true,
      },
    },
    window = {
      position = "float",
      width = "30%",
      popup = {
        position = { col = "100%", row = "2" },
        size = function(state)
          local root_name = vim.fn.fnamemodify(state.path, ":~")
          local root_len = string.len(root_name) + 4
          return {
            width = math.max(root_len, 50),
            height = vim.o.lines - 6,
          }
        end,
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_current",
      -- hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        never_show = { ".git" },
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          -- auto close
          require("neo-tree").close_all()
        end,
      },
    },
  })
  vim.cmd([[au FileType neo-tree lua vim.schedule(function() vim.cmd("setlocal buflisted") end)]])
end
