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

-- General config
require("general")

-- Plugins config
require("plugins")

-- Apply keybindings
require("plugins.binds").general()

-- NOTES

-- Automatically PackerCompile whenever plugins are updated
-- Need ripgrep for Telescope grep_string

-- TEMP: surround-wrap development
vim.o.rtp = vim.o.rtp .. vim.fn.expand(",~/dev/nvim-plugins/surround-wrap.nvim")
