local M = {}

function M.setup()
  vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "view buffer URLs" })
  vim.keymap.set("n", "\\U", "<Cmd>UrlView packer<CR>", { desc = "view plugin URLs" })
end

function M.config()
  require("urlview").setup({
    default_title = "Links",
    log_level_min = vim.log.levels.TRACE,
    jump = {
      prev = "[U",
      next = "]U",
    },
  })
end

return M
