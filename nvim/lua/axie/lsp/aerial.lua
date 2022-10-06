local M = {}

function M.config()
  require("aerial").setup({
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
  })

  local packer_aerial = vim.api.nvim_create_augroup("packer aerial symbols", {})
  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "set Aerial symbols collapse limit for plugins/init.lua",
    group = packer_aerial,
    pattern = {
      vim.fn.glob("~/dotconfig/nvim/lua/axie/plugins/init.lua"),
      vim.fn.glob("~/.config/nvim/lua/axie/plugins/init.lua"),
    },
    callback = function()
      vim.defer_fn(function()
        local ok, aerial = pcall(require, "aerial")
        if ok then
          aerial.tree_set_collapse_level(0, 1)
        end
      end, 0)
    end,
  })

  require("telescope").load_extension("aerial")
end

return M
