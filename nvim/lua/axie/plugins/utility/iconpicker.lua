local M = {}

M.cmd = {
  "IconPickerInsert",
  "IconPickerNormal",
  "IconPickerYank",
}

M.keys = {
  { "<A-i>", "<Cmd>IconPickerInsert<CR>", mode = "i", desc = "Icon picker" },
  { "<Space>fi", "<Cmd>IconPickerYank<CR>", desc = "Icon picker" },
}

M.opts = { disable_legacy_commands = true }

return M
