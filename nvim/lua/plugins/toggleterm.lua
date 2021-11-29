-- https://github.com/akinsho/toggleterm.nvim --
local M = {}

function M.attach()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
  vim.o.spell = false
end

function M.setup()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.ceil(vim.o.columns * 0.5)
      end
    end,
    float_opts = {
      width = math.ceil(vim.o.columns * 0.8),
      height = math.ceil(vim.o.lines * 0.8),
    },
  })
  vim.cmd("autocmd! TermOpen term://* lua require'plugins.toggleterm'.attach()")
  local map = require("utils").map
  map({ "n", "<F1>", "<CMD>1ToggleTerm direction=float<CR>" })
  map({ "i", "<F1>", "<CMD>1ToggleTerm direction=float<CR>" })
  map({ "t", "<F1>", "<CMD>1ToggleTerm direction=float<CR>" })
  -- NOTE: actually toggles instead of opening a new toggleterm?
  -- TODO: toggle vs more in same layout
  map({ "n", "<F2>", "<CMD>2ToggleTerm direction=horizontal<CR>" })
  map({ "i", "<F2>", "<CMD>2ToggleTerm direction=horizontal<CR>" })
  map({ "t", "<F2>", "<CMD>2ToggleTerm direction=horizontal<CR>" })
  map({ "n", "<F3>", "<CMD>3ToggleTerm direction=vertical<CR>" })
  map({ "i", "<F3>", "<CMD>3ToggleTerm direction=vertical<CR>" })
  map({ "t", "<F3>", "<CMD>3ToggleTerm direction=vertical<CR>" })
  map({ "n", "<F4>", "<CMD>4ToggleTerm direction=tab<CR>" })
  map({ "i", "<F4>", "<CMD>4ToggleTerm direction=tab<CR>" })
  map({ "t", "<F4>", "<CMD>4ToggleTerm direction=tab<CR>" })
end

function M.lazygit()
  local terminal = require("toggleterm.terminal").Terminal:new({
    cmd = "lazygit",
    direction = "float",
    -- hidden = true,
    count = 5,
    on_open = function(term)
      -- restore escape key
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", [[<esc><C-\><C-n>>]], { noremap = true })
    end,
  })
  terminal:toggle()
end

return M
