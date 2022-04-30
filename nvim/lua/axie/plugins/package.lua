-- https://github.com/vuki656/package-info.nvim --
return function()
  local package_info = require("package-info")
  package_info.setup()
  vim.keymap.set("n", "<space>ps", package_info.show, { desc = "Show package versions" })
  vim.keymap.set("n", "<space>pc", package_info.hide, { desc = "Hide package versions" })
  -- TODO: toggle
  vim.keymap.set("n", "<space>pu", package_info.update, { desc = "Update package on line" })
  vim.keymap.set("n", "<space>pd", package_info.delete, { desc = "Delete package on line" })
  vim.keymap.set("n", "<space>pi", package_info.install, { desc = "Install a new package" })
  vim.keymap.set("n", "<space>pr", package_info.reinstall, { desc = "Reinstall dependencies" })
  vim.keymap.set("n", "<space>pp", package_info.change_version, { desc = "Install a different package version" })
end
