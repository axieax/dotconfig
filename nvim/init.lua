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

-- General config
require("general")

-- Plugins config
require("plugins")(dev_mode)

-- Apply keybindings
require("plugins.binds").general()

-- Personal plugin development
if dev_mode then
  local plugins = require("utils").glob_split("~/dev/nvim-plugins/*")
  vim.opt.rtp:append(plugins)
end
