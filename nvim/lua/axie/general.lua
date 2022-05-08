local utils = require("axie.utils")
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
vim.cmd([[set listchars=tab:→\ ,trail:·,extends:▶,precedes:◀,nbsp:␣]])

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
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Disable relative numbers",
  group = numberToggleGroup,
  callback = function()
    vim.wo.relativenumber = false
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
vim.keymap.set({ "n", "v" }, "\\y", '"' .. yank_register .. "y", {
  desc = "yank to clipboard",
  noremap = false,
})

-- TODO: confirm
vim.keymap.set("n", "\\+", '<Cmd>let @+=@"<CR>', { desc = "paste from clipboard" })

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

-- No autoformat write
for _, cmd in ipairs({ "W", "Wq", "Wqa" }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    local lower_cmd = cmd:lower()
    local bang = ternary(opts.bang, "!", "")
    vim.cmd("noautocmd " .. lower_cmd .. bang)
  end, {
    bang = true,
  })
end

-- Quit typos
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("Qa", "qa", { bang = true })
vim.api.nvim_create_user_command("QA", "qa", { bang = true })

-- NOTE: want comment continue in some cases (e.g. java(s) docstring)
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "disable automatic comment insertion",
  callback = function()
    vim.o.formatoptions = vim.o.formatoptions:gsub("[cro]", "")
    vim.bo.formatoptions = vim.o.formatoptions
  end,
})

-- Center search result jumps
local center_keys = { "n", "N", "{", "}", "[g", "]g", "[s", "]s" }
for _, key in ipairs(center_keys) do
  vim.keymap.set("n", key, key .. "zz", { desc = "center after " .. key })
end

-- Resize windows
vim.keymap.set("n", "<C-k>", "<Cmd>resize -1<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>resize +1<CR>")
vim.keymap.set("n", "<C-h>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>vertical resize +1<CR>")

-- Wrapped cursor navigation
for _, key in ipairs({ "j", "k" }) do
  vim.keymap.set({ "n", "x" }, key, function()
    return vim.v.count > 0 and key or "g" .. key
  end, { desc = "wrapped lines cursor navigation with " .. key, expr = true, noremap = true })
end

vim.keymap.set("x", ".", ":norm.<CR>", { desc = "visual mode dot repeat" })
-- vim.keymap.set("x", "Q", ":'<,'>:normal @q<CR>", { desc = "apply normal mode macro q over visual selection" })
vim.keymap.set("x", "Q", function()
  local register = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd(":'<,'>:normal @" .. register .. "<CR>")
end)

local override_filetype = require("axie.utils").override_filetype

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
      vim.wo.spell = true
    end
  end,
})

-- CHECK: https://github.com/neovim/neovim/issues/14090#issuecomment-1113090354
vim.keymap.set("n", "<c-i>", "<c-i>")
