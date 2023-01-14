local M = {}

M.cmd = {
  "IconPickerInsert",
  "IconPickerNormal",
  "IconPickerYank",
}

function M.init()
  vim.keymap.set("i", "<A-i>", "<Cmd>IconPickerInsert<CR>", { desc = "Icon picker" })
  vim.keymap.set("n", "<Space>fi", "<Cmd>IconPickerYank<CR>", { desc = "Icon picker" })
end

M.opts = { disable_legacy_commands = true }

return M
