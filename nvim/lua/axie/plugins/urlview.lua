local M = {}

function M.setup()
  vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
  vim.keymap.set("n", "\\U", "<Cmd>UrlView packer<CR>", { desc = "view plugin URLs" })
end

function M.config()
  require("urlview").setup({
    default_title = "Links",
  })
end

return M
