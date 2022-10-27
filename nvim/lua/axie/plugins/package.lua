local M = {}

function M.config()
  local package_info = require("package-info")
  package_info.setup()

  -- TEMP: https://github.com/vuki656/package-info.nvim/pull/135
  package_info.toggle = function()
    if require("package-info.state").is_virtual_text_displayed then
      package_info.hide()
    else
      package_info.show()
    end
  end

  vim.keymap.set("n", ",pp", package_info.toggle, { desc = "Toggle package versions" })
  vim.keymap.set("n", ",pu", package_info.update, { desc = "Update package on line" })
  vim.keymap.set("n", ",pd", package_info.delete, { desc = "Delete package on line" })
  vim.keymap.set("n", ",pi", package_info.install, { desc = "Install a new package" })
  vim.keymap.set("n", ",pv", package_info.change_version, { desc = "Install a different package version" })
end

return M
