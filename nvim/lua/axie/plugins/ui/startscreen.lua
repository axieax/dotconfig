local M = {}

-- TODO: display startup time - async function + :AlphaRedraw?
-- TODO: customise like https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1308930
-- narrower center align

function M.update_startuptime(loaded_plugins, startuptime)
  local ok, dashboard = pcall(require, "alpha.themes.dashboard")
  if ok then
    dashboard.section.footer.val[2] = string.format("  %d plugins loaded in %.3f ms", loaded_plugins, startuptime)
  else
    require("axie.utils").notify("Failed to load dashboard from vim-startuptime", "error")
  end
end

function M.init()
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
    dashboard.button("n", "  New File", "<Cmd>ene<BAR>startinsert<CR>"),
    dashboard.button("f", "  Find Files", "<Cmd>lua require'axie.plugins.ui.telescope'.file_search()<CR>"),
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

  dashboard.section.footer.val = {
    "     https://github.com/axieax/",
    "", -- plugins loaded and startup time
  }

  require("alpha").setup(dashboard.config)

  local alpha_attach = vim.api.nvim_create_augroup("AlphaAttach", {})
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable alpha colorcolumn, show alpha in bufferline, calculate startuptime",
    group = alpha_attach,
    pattern = "alpha",
    callback = function()
      vim.opt_local.buflisted = true
      vim.opt_local.colorcolumn = ""
      vim.api.nvim_cmd({ cmd = "file", args = { "dashboard" } }, {})
    end,
  })
end

return M
