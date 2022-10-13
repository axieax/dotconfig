local M = {}

-- TODO: file nesting
-- TODO: group empty https://github.com/nvim-neo-tree/neo-tree.nvim/issues/552
-- TODO: highlight open buffers
-- TODO: file info (size, perms, time etc.)

function M.setup()
  vim.keymap.set("n", ";", "<Cmd>Neotree toggle<CR>", { desc = "file explorer" })
  vim.keymap.set("n", "<Space>fB", "<Cmd>Neotree source=buffers toggle<CR>", { desc = "open buffers (tree)" })
  vim.keymap.set("n", "<Space>G", "<Cmd>Neotree source=git_status toggle<CR>", { desc = "git status (tree)" })
  vim.keymap.set("n", "<Space>L", "<Cmd>Neotree source=diagnostics toggle<CR>", { desc = "git status (tree)" })
end

function M.config()
  require("neo-tree").setup({
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      "diagnostics",
    },
    source_selector = {
      winbar = true,
      tab_labels = {
        filesystem = "  Files ",
        buffers = "  Buffers ",
        git_status = "  Git ",
        diagnostics = " 裂LSP ",
      },
    },
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
          local bufnr = vim.api.nvim_get_current_buf()
          vim.schedule(function()
            local _, position = pcall(vim.api.nvim_buf_get_var, bufnr, "neo_tree_position")
            if position == "current" then
              vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
            end
          end)
        end,
      },
      {
        -- refresh winbar for non-current (NC) windows
        event = "neo_tree_window_after_close",
        handler = function()
          vim.schedule(require("axie.winbar").show_winbar)
        end,
      },
    },
  })
end

return M
