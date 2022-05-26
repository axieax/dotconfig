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

-- Lua reset require cache
local reload_module = require("axie.utils").reload_module
pcall(reload_module, "axie")

-- Source config files on save
local source_config = vim.api.nvim_create_augroup("SourceConfig", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Automatically source lua config files on save",
  group = source_config,
  pattern = { "*/dotconfig/nvim/**/*.lua", "*/.config/nvim/**/*.lua" },
  command = "source $MYVIMRC",
})

-- General config
require("axie.general")

-- Plugins config
require("axie.plugins")

-- Personal plugin development
local dev_mode = require("axie.utils.config").dev_mode
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
