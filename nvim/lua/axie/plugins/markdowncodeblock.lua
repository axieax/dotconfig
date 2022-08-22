local M = {}

function M.setup()
  vim.keymap.set("n", ",e", "<Cmd>FeMaco<CR>", { desc = "edit code block" })
end

function M.config()
  require("femaco").setup({ winblend = 10 })
end

return M
