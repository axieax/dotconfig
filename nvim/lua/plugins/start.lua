-- https://github.com/goolord/alpha-nvim --
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
    dashboard.button("b", "  Bookmarks", "<CMD>Telescope marks<CR>"),
    -- TODO: orgmode notes
    dashboard.button("o", "  Recent Files", "<CMD>Telescope oldfiles<CR>"), -- TODO: use frecency
    dashboard.button("p", "  Find Projects", "<CMD>Telescope projects<CR>"),
    dashboard.button("s", "  Restore Session", "<CMD>LoadLastSession<CR>"),
    dashboard.button("S", "  Find Sessions", "<CMD>Telescope sessions<CR>"),
    dashboard.button("c", "﫸 Neovim Config", "<CMD>e ~/.config/nvim/lua/plugins/init.lua<CR>"),
    dashboard.button("u", "  Update Plugins", "<CMD>PackerSync<CR>"),
    dashboard.button("q", "⏻  Quit Neovim", "<CMD>qa<CR>"),
  }

  dashboard.section.footer.val = "  https://github.com/axieax/"

  require("alpha").setup(dashboard.opts)
end
