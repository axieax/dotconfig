local M = {}

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

--- Protected require for loading a specific plugin config
---@param plugin (string) plugin to load (default in `axie.plugins.{}` unless specified otherwise)
---@param config_type (string) type of config to load (`setup` or `config`)
---@return function
local function use_config(plugin, config_type)
  if not string.match(plugin, "%.") then
    plugin = string.format("plugins.%s", plugin)
  end
  local ok, mod = pcall(require, "axie." .. plugin)
  if not ok then
    M.notify("Could not load plugin: " .. plugin)
    return function() end
  end
  if type(mod) ~= "table" then
    M.notify(string.format("expected %s to be a table", plugin))
    return function() end
  end
  return mod[config_type]
end

--- Decorate packer `use` function with custom config
---@param packer_use function from packer
---@return function
function M.customise_use(packer_use)
  return function(config, custom)
    if custom then
      if type(config) == "string" then
        config = { config }
      end
      local path, types = unpack(custom)
      for _, type in ipairs(types) do
        config[type] = use_config(path, type)
      end
    end
    return packer_use(config)
  end
end

function M.config()
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
