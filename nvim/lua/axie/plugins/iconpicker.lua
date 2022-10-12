local M = {}

function M.setup()
  vim.keymap.set("i", "<C-i>", "<Cmd>IconPickerInsert<CR>", { desc = "icon picker" })
  vim.keymap.set("n", "\\i", "<Cmd>IconPickerYank<CR>", { desc = "icon picker" })
end

function M.config()
  require("icon-picker").setup({
    disable_legacy_commands = true,
  })
end

return M
