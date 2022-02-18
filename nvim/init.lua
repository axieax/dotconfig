-----------------------------------------------------------
-----------------------------------------------------------
--    _____  ____  ___.______________   _____  ____  ___ --
--   /  _  \ \   \/  /|   \_   _____/  /  _  \ \   \/  / --
--  /  /_\  \ \     / |   ||    __)_  /  /_\  \ \     /  --
-- /    |    \/     \ |   ||        \/    |    \/     \  --
-- \____|__  /___/\  \|___/_______  /\____|__  /___/\  \ --
--         \/      \_/            \/         \/      \_/ --
-----------------------------------------------------------
-----------------------------------------------------------

-- NOTES:
-- Need ripgrep for Telescope grep_string

local dev_mode = false

-- Lua require caching
local reload_module = require("axie.utils").reload_module
reload_module("axie")

-- General config
require("axie.general")

-- Plugins config
require("axie.plugins")(dev_mode)

-- Apply keybindings
require("axie.plugins.binds").general()

-- Personal plugin development
if dev_mode then
  -- NOTE: automatic detection cannot find module names
  -- local plugins = require("axie.utils").glob_split("~/dev/nvim-plugins/*")
  -- vim.opt.rtp:append(plugins)

  local base_path = "~/dev/nvim-plugins/"
  local dev_plugins = {
    {
      plugin_name = "urlview.nvim",
      module_names = { "urlview" },
    },
    {
      plugin_name = "surround-wrap.nvim",
      module_names = { "surround_wrap" },
    },
  }

  for _, dev_plugin in ipairs(dev_plugins) do
    vim.opt.rtp:append(base_path .. dev_plugin.plugin_name)
    for _, module_name in ipairs(dev_plugin.module_names) do
      reload_module(module_name)
    end
  end

end
