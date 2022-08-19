local M = {}

local utils = require("axie.utils")
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

function M.is_installed()
  return vim.fn.empty(vim.fn.glob(packer_path)) == 0
end

function M.auto_bootstrap()
  if M.is_installed() then
    return false
  end
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
  vim.cmd("packadd packer.nvim")
  return true
end

local packer_options = {
  "config",
  "setup",
  "cmd",
}

--- Update packer `use` to auto-fill options if a config module is specified
---@param packer_use function from packer
---@return function
function M.customise_use(packer_use)
  return function(config, mod_name, additional_options)
    if type(config) == "string" then
      config = { config }
    end
    local plugin_name = config[1]
    if mod_name then
      if type(mod_name) ~= "string" then
        utils.notify(string.format("%s: expected module name as string", plugin_name))
        return
      end

      if not string.match(mod_name, "%.") then
        mod_name = string.format("plugins.%s", mod_name)
      end
      local ok, mod = pcall(require, "axie." .. mod_name)
      if not ok then
        utils.notify(string.format("%s: failed to load module %s", plugin_name, mod_name))
        return
      end

      local options = vim.tbl_extend("force", packer_options, additional_options or {})
      for _, type in ipairs(options) do
        if mod[type] then
          config[type] = mod[type]
        end
      end
    end
    return packer_use(config)
  end
end

function M.setup()
  vim.keymap.set("n", "<Space>s", function()
    local snapshot_time = os.date("!%Y-%m-%dT%TZ")
    vim.cmd("PackerSnapshot " .. snapshot_time)
    vim.cmd("PackerSync")
  end, { desc = "sync plugins" })
end

function M.config()
  M.setup()

  return {
    -- actually reload catppuccin setup function without restarting nvim
    auto_reload_compiled = true,
    -- https://github.com/wbthomason/packer.nvim/issues/202
    max_jobs = 50,
    -- https://github.com/wbthomason/packer.nvim/issues/381#issuecomment-849815901
    -- git = {
    --   subcommands = {
    --     update = "pull --ff-only --progress --rebase",
    --   },
    -- },
    profile = { enable = true },
    autoremove = true,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
  }
end

return M
