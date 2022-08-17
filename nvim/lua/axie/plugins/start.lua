local M = {}

-- TODO: display startup time - async function + :AlphaRedraw?
-- TODO: customise like https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1308930
-- narrower center align

function M.setup()
  vim.keymap.set("n", "<Space>S", "<Cmd>Alpha<CR>", { desc = "start menu" })
end

function M.config()
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
    dashboard.button("n", "  New File", "<Cmd>ene <BAR> startinsert<CR>"),
    dashboard.button("f", "  Find Files", "<Cmd>lua require'axie.plugins.telescope'.file_search()<CR>"),
    dashboard.button("g", "  Live Grep", "<Cmd>Telescope live_grep<CR>"),
    dashboard.button("b", "  Bookmarks", "<Cmd>Telescope marks<CR>"),
    -- TODO: orgmode notes
    dashboard.button("o", "  Recent Files", "<Cmd>Telescope oldfiles<CR>"), -- TODO: use frecency
    dashboard.button("p", "  Find Projects", "<Cmd>Telescope projects<CR>"),
    dashboard.button("s", "  Restore Session", "<Cmd>SessionManager load_last_session<CR>"),
    dashboard.button("S", "  Find Sessions", "<Cmd>SessionManager load_session<CR>"),
    dashboard.button("c", "﫸 Neovim Config", "<Cmd>e ~/.config/nvim/lua/plugins/init.lua<CR>"),
    dashboard.button("u", "  Update Plugins", "<Cmd>PackerSync<CR>"),
    dashboard.button("q", "⏻  Quit Neovim", "<Cmd>qa<CR>"),
  }

  local glob_split = require("axie.utils").glob_split
  local start_plugins = #glob_split("~/.local/share/nvim/site/pack/packer/start/*")
  local opt_plugins = #glob_split("~/.local/share/nvim/site/pack/packer/opt/*")
  dashboard.section.footer.val = {
    string.format("   %d plugins (%d loaded)", start_plugins + opt_plugins, start_plugins),
    "  https://github.com/axieax/",
  }

  require("alpha").setup(dashboard.config)

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable alpha colorcolumn, show alpha in bufferline",
    pattern = "alpha",
    callback = function()
      vim.bo.buflisted = true
      vim.wo.colorcolumn = ""
      vim.cmd("file dashboard")
    end,
  })
end

return M
