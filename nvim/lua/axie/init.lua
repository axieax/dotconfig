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
  command = "source $MYVIMRC | source %",
})

-- General config
require("axie.general")

-- Plugins config
require("axie.plugins")

-- Personal plugin development
local dev_mode = require("axie.utils.config").dev_mode
if dev_mode then
  local base_path = vim.fn.expand("~/dev/nvim-plugins/")
  local paths = require("axie.utils").glob_split(base_path .. "*", vim.pesc(base_path))
  for _, path in ipairs(paths) do
    local module_name = path:gsub("%.nvim", "")
    -- module_name = module_name:gsub("%-", "")
    -- add to rtp
    vim.opt.rtp:append(base_path .. path)
    -- refresh require caching
    reload_module(module_name)
    -- load config
    local ok, mod = pcall(require, "axie.plugins." .. module_name)
    if ok then
      local mod_types = { "setup", "config" }
      for _, mod_type in ipairs(mod_types) do
        local mod_func = mod[mod_type]
        if mod_func then
          mod_func()
        end
      end
    end
  end
end
