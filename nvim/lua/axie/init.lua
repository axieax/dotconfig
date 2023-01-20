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
require("axie.general")
require("axie.general.options")
require("axie.general.keymaps")

-- Plugins config
require("axie.lazy").setup()

-- Set up language servers
require("axie.plugins.lsp.setup").servers()

-- Winbar
require("axie.winbar").activate()
