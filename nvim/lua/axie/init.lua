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

-- NOTE: need ripgrep for Telescope grep_string

local dev_mode = false

-- Lua require caching
local reload_module = require("axie.utils").reload_module
reload_module("axie")

-- General config
require("axie.general")

-- Plugins config
require("axie.plugins")(dev_mode)

-- Personal plugin development
if dev_mode then
  local base_path = vim.fn.expand("~/dev/nvim-plugins/")
  local escaped_base_path = base_path:gsub("%-", "%%-")

  local paths = require("axie.utils").glob_split(base_path .. "*")
  for _, path in ipairs(paths) do
    local module_name = path:gsub(escaped_base_path, ""):gsub("%.nvim", "")
    -- module_name = module_name:gsub("%-", "_")
    -- add to rtp
    vim.opt.rtp:append(path)
    -- refresh require caching
    reload_module(module_name)
  end

  -- Custom config
  require("axie.plugins.urlview")()
end
