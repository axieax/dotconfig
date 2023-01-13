local M = {}

M.cmd = {
  "IconPickerInsert",
  "IconPickerNormal",
  "IconPickerYank",
}

function M.init()
  vim.keymap.set("i", "<A-i>", "<Cmd>IconPickerInsert<CR>", { desc = "icon picker" })
  vim.keymap.set("n", "\\i", "<Cmd>IconPickerYank<CR>", { desc = "icon picker" })
end

M.opts = { disable_legacy_commands = true }

return M
