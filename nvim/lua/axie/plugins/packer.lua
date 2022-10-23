local M = {}

local utils = require("axie.utils")
local dev_mode = require("axie.utils.config").dev_mode
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

function M.auto_bootstrap()
  local should_bootstrap = vim.loop.fs_stat(packer_path) == nil
  if should_bootstrap then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
    vim.api.nvim_cmd({ cmd = "packadd", args = { "packer.nvim" } }, {})
  end
  return should_bootstrap
end

local packer_options = {
  -- "cmd",
  "run",
  "setup",
  "config",
}

--- Update packer `use` to auto-fill options if a config module is specified
---@param packer_use function from packer
---@param for_dev_plugins boolean whether `use` is for configuring dev plugins
---@return function
function M.customise_use(packer_use, for_dev_plugins)
  return function(config, mod_name, additional_options)
    if type(config) == "string" then
      config = { config }
    end
    local plugin_name = config[1]
    if for_dev_plugins then
      config.disable = dev_mode
    end

    if mod_name then
      if type(mod_name) ~= "string" then
        utils.notify(string.format("%s: expected module name as string", plugin_name), "error")
        return
      end

      if not string.match(mod_name, "%.") then
        mod_name = string.format("plugins.%s", mod_name)
      end
      local ok, mod = pcall(require, "axie." .. mod_name)
      if not ok then
        utils.notify(string.format("%s: failed to load module %s", plugin_name, mod_name), "error")
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
    vim.api.nvim_cmd({ cmd = "PackerSnapshot", args = { snapshot_time } }, {})
    vim.api.nvim_cmd({ cmd = "PackerSync" }, {})
  end, { desc = "sync plugins" })
end

M.config = {
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

return M
