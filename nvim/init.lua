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

-- -- Need better Vim event since currently this may result in an infinite loop
-- -- BUG: calling LspInstall brings up another prompt (buffer)..
-- vim.cmd("autocmd BufEnter * lua auto_lsp_install()")

-- Need ripgrep for Telescope grep_string
