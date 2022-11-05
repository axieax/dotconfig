local M = {}

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
    on_attach = function(bufnr)
      -- set fold level for Packer plugins config
      local name = vim.api.nvim_buf_get_name(bufnr)
      local matches = {
        vim.fn.expand("~/dotconfig/nvim/lua/axie/plugins/init.lua"),
        vim.fn.expand("~/.config/nvim/lua/axie/plugins/init.lua"),
      }
      if vim.tbl_contains(matches, name) then
        aerial.tree_set_collapse_level(bufnr, 1)
      end
    end,
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

  vim.keymap.set("n", "<Space><Tab>", "<Cmd>AerialToggle<CR>", { desc = "Aerial Symbols" })
  require("telescope").load_extension("aerial")
end

return M
