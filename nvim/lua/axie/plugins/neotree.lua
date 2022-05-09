-- https://github.com/nvim-neo-tree/neo-tree.nvim --
-- TODO: file nesting
-- TODO: group empty https://github.com/nvim-neo-tree/neo-tree.nvim/issues/211
-- TODO: highlight open buffers
-- TODO: remove nvimtree
-- TODO: file preview / info (size, perms, time etc.)
-- TODO: update git / diagnostic icons/colours

local M = {}

function M.setup()
  require("neo-tree").setup({
    use_popups_for_input = false,
    -- popup_border_style = "rounded",
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
      mappings = {
        -- relative path in add prompt
        a = {
          "add",
          config = { show_path = "relative" },
        },
        A = {
          -- "add_directory",
          -- config = { show_path = "relative" },
          "add",
          config = { show_path = "absolute" },
        },
      },
    },
    filesystem = {
      group_empty_dirs = true,
      bind_to_cwd = false,
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        never_show = { ".git" },
      },
    },
    event_handlers = {
      {
        -- auto close
        event = "file_opened",
        handler = function(file_path)
          require("neo-tree").close_all()
        end,
      },
      {
        -- show netrw hijacked buffer in buffer list
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.schedule(function()
            local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
            if position == "current" then
              vim.bo.buflisted = true
            end
          end)
        end,
      },
    },
  })
end

function M.binds()
  vim.keymap.set("n", ";", "<Cmd>Neotree toggle=true<CR>", { desc = "file explorer" })
  vim.keymap.set("n", "<Space>gS", "<Cmd>Neotree source=git_status toggle=true<CR>", { desc = "git status (tree)" })
  vim.keymap.set("n", "<Space>fB", "<Cmd>Neotree source=buffers toggle=true<CR>", { desc = "find buffers (tree)" })
end

return M
