local M = {}

-- TODO: warn before exit if hidden floaterm active

M.cmd = {
  "TermSelect",
  "TermExec",
  "ToggleTerm",
  "ToggleTermToggleAll",
  "ToggleTermSendVisualLines",
  "ToggleTermSendVisualSelection",
  "ToggleTermSendCurrentLine",
  "ToggleTermSetName",
}

function M.attach()
  vim.keymap.set("n", "<Esc>", "<Nop>", { silent = true, buffer = 0 })
  vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], { desc = "Toggle mode", buffer = 0 })
  vim.keymap.set("n", "<C-]>", "<Cmd>startinsert<CR>", { desc = "Toggle mode", buffer = 0 })
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
end

function M.init()
  local this = require("axie.plugins.ui.toggleterm")
  local filetype_map = require("axie.utils").filetype_map
  local require_args = require("axie.utils").require_args
  filetype_map("html", "n", ",o", require_args(this.liveserver, true), {
    desc = "Start liveserver for current file",
  })
  filetype_map("html", "n", ",O", require_args(this.liveserver, false), {
    desc = "Start liveserver for current project",
  })

  vim.keymap.set("n", "<Space>gg", this.lazygit, { desc = "Lazygit" })
  vim.keymap.set("n", "<Space>gG", this.lazydocker, { desc = "Lazydocker" })

  -- NOTE: actually toggles instead of opening a new toggleterm?
  -- TODO: toggle vs more in same layout
  local directions = { "float", "horizontal", "vertical", "tab" }
  for i, direction in ipairs(directions) do
    vim.keymap.set(
      { "n", "i", "t" },
      string.format("<F%d>", i),
      string.format("<Cmd>%dToggleTerm direction=%s<CR>", i, direction),
      { desc = "Toggleterm " .. direction }
    )
  end
  vim.keymap.set({ "n", "i", "t" }, [[<C-\>]], "<Cmd>Telescope termfinder find<CR>", { desc = "Find terminals" })
end

function M.config()
  require("toggleterm").setup({
    persist_mode = false,
    close_on_exit = false,
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
    desc = "Toggleterm attach",
    pattern = "term://*",
    callback = require("axie.plugins.ui.toggleterm").attach,
  })
  vim.api.nvim_create_autocmd("TermClose", {
    desc = "Close terminal buffers on success",
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(0, {})
      end
    end,
  })
end

function M.lazygit()
  local lazygit = require("toggleterm.terminal").Terminal:new({
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
    cmd = "lazydocker",
    direction = "float",
    -- float_opts = { highlights = { border = "Normal" } },
    hidden = true,
    count = 6,
  })
  lazydocker:toggle()
end

function M.liveserver(current_file)
  local filename = (current_file or false) and vim.fn.expand("%") or ""
  local liveserver = require("toggleterm.terminal").Terminal:new({
    -- INSTALL: npm install -g live-server
    cmd = "live-server " .. filename,
    direction = "float",
    -- float_opts = { highlights = { border = "Normal" } },
    hidden = true,
    count = 7,
    on_open = function()
      vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<Cmd>close<CR>", { silent = true })
    end,
  })
  liveserver:toggle()
end

return M
