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

-- Winbar
require("axie.winbar").activate()

-- Plugins config
require("axie.lazy").setup()

-- Set colorscheme
local ok, res = pcall(vim.api.nvim_cmd, { cmd = "colorscheme", args = { "catppuccin" } }, {})
if not ok then
  vim.notify(string.format("Failed to set colorscheme: %s", res))
end

-- Set up language servers
require("axie.plugins.lsp.setup").servers()
