local M = {}

-- TODO: warn before exit if hidden floaterm active

function M.attach()
  vim.keymap.set("n", "<Esc>", "<Nop>", { silent = true, buffer = 0 })
  vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], { desc = "toggle mode", buffer = 0 })
  vim.keymap.set("n", "<C-]>", "<Cmd>startinsert<CR>", { desc = "toggle mode", buffer = 0 })
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
end

function M.config()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.ceil(vim.o.columns * 0.5)
      end
    end,
    float_opts = {
      border = "curved",
      width = math.ceil(vim.o.columns * 0.8),
      height = math.ceil(vim.o.lines * 0.8),
      highlights = {
        border = "FloatBorder",
      },
    },
  })
  vim.api.nvim_create_autocmd("TermOpen", {
    desc = "toggleterm attach",
    pattern = "term://*",
    callback = require("axie.plugins.toggleterm").attach,
  })

  -- NOTE: actually toggles instead of opening a new toggleterm?
  -- TODO: toggle vs more in same layout
  local directions = { "float", "horizontal", "vertical", "tab" }
  for i, direction in ipairs(directions) do
    vim.keymap.set(
      { "n", "i", "t" },
      string.format("<F%d>", i),
      string.format("<Cmd>%dToggleTerm direction=%s<CR>", i, direction)
    )
  end
  vim.keymap.set({ "n", "i", "t" }, [[<C-\>]], "<Cmd>Telescope termfinder find<CR>", { desc = "find terminals" })

  -- Custom terminals
  local this = require("axie.plugins.toggleterm")
  local filetype_map = require("axie.utils").filetype_map
  local require_args = require("axie.utils").require_args
  filetype_map("html", "n", ",o", require_args(this.liveserver, true), {
    desc = "start liveserver for current file",
  })
  filetype_map("html", "n", ",O", require_args(this.liveserver, false), {
    desc = "start liveserver for current project",
  })

  vim.keymap.set("n", "<space>gg", this.lazygit, { desc = "lazygit" })
  vim.keymap.set("n", "<space>gG", this.lazydocker, { desc = "lazydocker" })

  require("telescope").load_extension("termfinder")
end

function M.lazygit()
  local lazygit = require("toggleterm.terminal").Terminal:new({
    -- INSTALL: sudo pacman -S lazygit
    cmd = "lazygit",
    direction = "float",
    -- float_opts = { highlights = { border = "Normal" } },
    hidden = true,
    count = 5,
  })
  lazygit:toggle()
end

function M.lazydocker()
  local lazydocker = require("toggleterm.terminal").Terminal:new({
    -- INSTALL: sudo pacman -S lazydocker
    cmd = "lazydocker",
    direction = "float",
    -- float_opts = { highlights = { border = "Normal" } },
    hidden = true,
    count = 6,
  })
  lazydocker:toggle()
end

function M.liveserver(current_file)
  local filename = require("axie.utils").ternary(current_file or false, vim.fn.expand("%"), "")
  local liveserver = require("toggleterm.terminal").Terminal:new({
    -- INSTALL: yarn global add live-server
    cmd = "live-server " .. filename,
    direction = "float",
    -- float_opts = { highlights = { border = "Normal" } },
    hidden = true,
    count = 7,
    on_open = function(t)
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<Cmd>close<CR>", { silent = true })
    end,
  })
  liveserver:toggle()
end

return M
