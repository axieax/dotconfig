-- https://github.com/akinsho/toggleterm.nvim --

-- TODO: warn before exit if hidden floaterm active

local M = {}

function M.attach()
  local opts = { noremap = true }
  -- vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<CMD>close<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<CMD>noh<CR>", { silent = true })
  -- vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", [[<a-\>]], [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "n", [[<a-\>]], "<CMD>startinsert<CR>", opts)
  vim.wo.spell = false
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
      border = "curved",
      width = math.ceil(vim.o.columns * 0.8),
      height = math.ceil(vim.o.lines * 0.8),
      highlights = {
        border = "FloatBorder",
      },
    },
  })
  vim.cmd("autocmd! TermOpen term://* lua require'axie.plugins.toggleterm'.attach()")

  local map = require("axie.utils").map
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
  map({ "n", [[<C-\>]], "<CMD>Telescope termfinder find<CR>" })
  map({ "i", [[<C-\>]], "<CMD>Telescope termfinder find<CR>" })
  map({ "t", [[<C-\>]], "<CMD>Telescope termfinder find<CR>" })

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
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", "<CMD>close<CR>", { silent = true })
    end,
  })
  liveserver:toggle()
end

return M
