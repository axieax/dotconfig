local utils = require("axie.utils")
local override_filetype = utils.override_filetype

-- Disable relative numbers for insert mode
local numberToggleGroup = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Enable relative numbers",
  group = numberToggleGroup,
  callback = function()
    local ignored = { "TelescopePrompt" }
    if not vim.tbl_contains(ignored, vim.bo.filetype) then
      vim.opt_local.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Disable relative numbers",
  group = numberToggleGroup,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "autoresize nvim",
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Write and quit typos
local typos = { "W", "Wq", "WQ", "Wqa", "WQa", "WQA", "WqA", "Q", "Qa", "QA" }
for _, cmd in ipairs(typos) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_cmd({
      cmd = cmd:lower(),
      bang = opts.bang,
      mods = { noautocmd = true },
    }, {})
  end, { bang = true })
end

-- Terraform filetypes
override_filetype({ ".*%.terraformrc", ".*%.terraform.rc" }, "terraform")
override_filetype({ ".*%.tfstate" }, "json")
