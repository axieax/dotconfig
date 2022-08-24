local M = {}

function M.setup()
  vim.keymap.set("n", ",e", "<Cmd>FeMaco<CR>", { desc = "edit code block" })
end

function M.config()
  require("femaco").setup({
    post_open_float = function(winnr)
      vim.api.nvim_win_set_option(winnr, "winblend", 10)
    end,
  })
end

return M
