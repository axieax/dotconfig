local M = {}

function M.setup()
  local options = "alt_font symbols nerd_font emoji"
  vim.keymap.set("i", "<c-i>", string.format("<Cmd>IconPickerInsert %s<CR>", options), { desc = "icon picker" })
  vim.keymap.set("n", "\\i", string.format("<Cmd>IconPickerYank %s<CR>", options), { desc = "icon picker" })
end

function M.config()
  require("icon-picker").setup({
    disable_legacy_commands = true,
  })
end

return M
