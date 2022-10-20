local utils = require("axie.utils")
local override_filetype = utils.override_filetype
local vim_apply = utils.vim_apply
local ternary = utils.ternary

---------------
-- Variables --
---------------
-- Global variables - vim.g
-- Buffer variables - vim.b
-- Window variables - vim.w
-- Tabpage variables - vim.t
-- Predefined Vim variables - vim.v
-- Environment variables - vim.env
-- Options (:set) - vim.o
-- Global options (:setglobal) - vim.go
-- Buffer options (:setlocal for buffer-local options) - vim.bo
-- Window options (:setlocal for window-local options) - vim.wo

-- TODO: writebackup
-- https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim#L94-L99
vim_apply(vim.opt, {
  -- General options
  mouse = "a",
  -- spell = true,
  scrolloff = 1,
  sidescrolloff = 2,
  cursorline = true,
  splitbelow = true,
  splitright = true,
  hidden = true,
  number = true,
  relativenumber = true,
  ruler = true,
  colorcolumn = "80",
  termguicolors = true,
  showmode = false,
  swapfile = false,
  undofile = true, -- persistent undo
  -- updatetime = 1500,

  list = true,
  -- listchars = [[tab:→\ ,trail:·,extends:▶,precedes:◀,nbsp:␣]], -- set below due to Lua backslash escape

  wildmenu = true,
  wildmode = "full",
  wildoptions = "tagfile",
  autoread = true,
  pumblend = 15,

  showmatch = true,
  hlsearch = true,
  incsearch = true, -- live search preview
  inccommand = "split", -- live substitution preview
  ignorecase = true,
  smartcase = true,

  -- Coding options
  -- https://arisweedler.medium.com/tab-settings-in-vim-1ea0863c5990
  expandtab = true,
  shiftwidth = 2,
  softtabstop = 2,
  tabstop = 2,
  autoindent = true,
  smartindent = true,
  -- cindent = true, -- fix markdown code block indents, but may randomly indent sometimes
})

-- NOTE: indent-blankline covers first tab character
vim.cmd.set([[listchars=tab:→\ ,trail:·,extends:▶,precedes:◀,nbsp:␣]])

----------
-- Misc --
----------

-- Disable relative numbers for insert mode
local numberToggleGroup = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Enable relative numbers",
  group = numberToggleGroup,
  callback = function()
    local ignored = { "TelescopePrompt" }
    if not vim.tbl_contains(ignored, vim.bo.filetype) then
      vim.opt_local.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Disable relative numbers",
  group = numberToggleGroup,
  callback = function()
    vim.opt_local.relativenumber = false
  end,
})

-- netrw settings (for directory tree view)
vim_apply(vim.g, {
  -- loaded_netrw = 1, -- disables netrw
  netrw_liststyle = 3, -- tree style
  netrw_preview = 1, -- vertical splits for previews
  netrw_altv = true, -- opens vsplit to right
})

local yank_register = ternary(vim.loop.os_uname().sysname == "Linux", "+", "*")
vim.keymap.set({ "n", "v" }, "\\y", '"' .. yank_register .. "y", { desc = "yank to clipboard" })
vim.keymap.set("n", "\\+", '<Cmd>let @+=@"<CR>', { desc = "copy internal yank content to clipboard" })
vim.keymap.set({ "n", "v" }, "\\p", '"0p', { desc = "paste last yanked" })

vim.api.nvim_create_autocmd("VimResized", {
  desc = "autoresize nvim",
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Update (instead of write)
vim.keymap.set("n", "<space>w", "<Cmd>update<CR>")

-- Write and quit typos
local typos = { "W", "Wq", "WQ", "Wqa", "WQa", "WQA", "WqA", "Q", "Qa", "QA" }
for _, cmd in ipairs(typos) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_cmd({
      cmd = cmd:lower(),
      bang = opts.bang,
      mods = { noautocmd = true },
    }, {})
  end, { bang = true })
end

-- NOTE: want comment continue in some cases (e.g. java(s) docstring)
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "disable automatic comment insertion",
  callback = function()
    vim.o.formatoptions = vim.o.formatoptions:gsub("[cro]", "")
    vim.opt_local.formatoptions = vim.o.formatoptions
  end,
})

-- Center search result jumps
local center_keys = { "n", "N", "{", "}", "*", "[g", "]g", "[s", "]s", "[m", "]m" }
for _, key in ipairs(center_keys) do
  vim.keymap.set("n", key, key .. "zz", { desc = "center after " .. key })
end

-- Resize windows
vim.keymap.set("n", "<C-w>K", "<Cmd>resize -1<CR>")
vim.keymap.set("n", "<C-w>J", "<Cmd>resize +1<CR>")
vim.keymap.set("n", "<C-w>H", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "<C-w>L", "<Cmd>vertical resize +1<CR>")
vim.keymap.set("n", "H", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "L", "<Cmd>vertical resize +1<CR>")

-- Wrapped cursor navigation
for _, key in ipairs({ "j", "k" }) do
  vim.keymap.set({ "n", "x" }, key, function()
    return vim.v.count > 0 and key or "g" .. key
  end, { desc = "wrapped lines cursor navigation with " .. key, expr = true })
end

vim.keymap.set("x", ".", ":norm.<CR>", { desc = "visual mode dot repeat" })
vim.keymap.set("x", "Q", function()
  local register = vim.fn.nr2char(vim.fn.getchar()) -- get register from user
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(":normal @" .. register .. "<CR>", true, false, true))
end, { desc = "apply normal macro over visual selection" })

-- Terraform files
override_filetype({ "*.terraformrc", "*.terraform.rc" }, "terraform")
override_filetype({ "*.tfstate" }, "json")

-- Bazel files
override_filetype({ "BUILD.*", "WORKSPACE.*" }, "bzl")

-- Enable spellcheck conditionally based on filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "enable spellcheck",
  callback = function()
    local ft = vim.bo.filetype
    local enabled_filetypes = { "markdown", "text", "" }
    if vim.tbl_contains(enabled_filetypes, ft) or vim.fn.empty(vim.bo.filetype) ~= 0 then
      vim.opt_local.spell = true
    end
  end,
})

-- CHECK: https://github.com/neovim/neovim/issues/14090#issuecomment-1113090354
vim.keymap.set("n", "<C-i>", "<C-i>")

-- Winbar
require("axie.winbar").activate()
