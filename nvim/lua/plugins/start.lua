-- https://github.com/goolord/alpha-nvim --
-- TODO: display startup time - async function + :AlphaRedraw?
-- TODO: customise like https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1308930
-- narrower center align

return function()
  local dashboard = require("alpha.themes.dashboard")

  dashboard.section.header.val = {
    [[   _____  ____  ___.______________   _____  ____  ___]],
    [[  /  _  \ \   \/  /|   \_   _____/  /  _  \ \   \/  /]],
    [[ /  /_\  \ \     / |   ||    __)_  /  /_\  \ \     / ]],
    [[/    |    \/     \ |   ||        \/    |    \/     \ ]],
    [[\____|__  /___/\  \|___/_______  /\____|__  /___/\  \]],
    [[        \/      \_/            \/         \/      \_/]],
    [[                                                     ]],
    [[     > Press [s] to restore your last session <      ]],
  }

  dashboard.section.buttons.val = {
    dashboard.button("n", "  New File", "<CMD>ene <BAR> startinsert<CR>"),
    dashboard.button("f", "  Find Files", "<CMD>lua require'plugins.telescope'.file_search()<CR>"),
    dashboard.button("g", "  Live Grep", "<CMD>Telescope live_grep<CR>"),
    dashboard.button("b", "  Bookmarks", "<CMD>Telescope marks<CR>"),
    -- TODO: orgmode notes
    dashboard.button("o", "  Recent Files", "<CMD>Telescope oldfiles<CR>"), -- TODO: use frecency
    dashboard.button("p", "  Find Projects", "<CMD>Telescope projects<CR>"),
    dashboard.button("s", "  Restore Session", "<CMD>SessionManager load_last_session<CR>"),
    dashboard.button("S", "  Find Sessions", "<CMD>SessionManager load_session<CR>"),
    dashboard.button("c", "﫸 Neovim Config", "<CMD>e ~/.config/nvim/lua/plugins/init.lua<CR>"),
    dashboard.button("u", "  Update Plugins", "<CMD>PackerSync<CR>"),
    dashboard.button("q", "⏻  Quit Neovim", "<CMD>qa<CR>"),
  }

  local glob_split = require("utils").glob_split
  local start_plugins = #glob_split("~/.local/share/nvim/site/pack/packer/start/*")
  local opt_plugins = #glob_split("~/.local/share/nvim/site/pack/packer/opt/*")
  dashboard.section.footer.val = {
    string.format("   %d plugins (%d loaded)", start_plugins + opt_plugins, start_plugins),
    "  https://github.com/axieax/",
  }

  require("alpha").setup(dashboard.config)
end
