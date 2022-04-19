local utils = require("axie.utils")
local vim_apply = utils.vim_apply
local map = utils.map
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
  ruler = true,
  colorcolumn = "80",
  termguicolors = true,
  showmode = false,
  swapfile = false,
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
vim.cmd([[
  set listchars=tab:→\ ,trail:·,extends:▶,precedes:◀,nbsp:␣
]])

----------
-- Misc --
----------

-- Hybrid relative numbers for normal mode, absolute for insert mode
local numberToggleGroup = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = numberToggleGroup,
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "alpha" then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = numberToggleGroup,
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Disable colorcolumn conditionally
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.wo.colorcolumn = ""
  end,
})

-- netrw settings (for directory tree view)
vim_apply(vim.g, {
  -- loaded_netrw = 1, -- disables netrw
  netrw_liststyle = 3, -- tree style
  netrw_preview = 1, -- vertical splits for previews
  netrw_altv = true, -- opens vsplit to right
})

-- Clipboard yank
local yank_register = ternary(vim.loop.os_uname().sysname == "Linux", "+", "*")
map({ "n", "\\y", '"' .. yank_register .. "y", noremap = false })
map({ "v", "\\y", '"' .. yank_register .. "y", noremap = false })

-- Paste to clipboard
map({ "n", "\\+", '<CMD>let @+=@"<CR>' })

-- Paste last yanked
map({ "n", "\\p", '"0p' })
map({ "v", "\\p", '"0p' })

-- Auto-resize
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Update (instead of write)
map({ "n", "<space>w", "<CMD>update<CR>" })

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

-- Disable automatic comment insertion
-- NOTE: want comment continue in some cases (e.g. java(s) docstring)
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Center search result jumps
map({ "n", "N", "Nzz" })
map({ "n", "n", "nzz" })

-- Resize windows
map({ "n", "<C-k>", "<CMD>resize -1<CR>" })
map({ "n", "<C-j>", "<CMD>resize +1<CR>" })
map({ "n", "<C-h>", "<CMD>vertical resize -1<CR>" })
map({ "n", "<C-l>", "<CMD>vertical resize +1<CR>" })

-- Wrapped cursor navigation
vim.cmd("noremap <expr> j v:count ? 'j' : 'gj'")
vim.cmd("noremap <expr> k v:count ? 'k' : 'gk'")

-- TODO: migrate to ftdetect?
-- NOTE: BufEnter vs BufRead,BufNewFile
-- Terraform filetype
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.terraformrc", "*.terraform.rc" },
  callback = function()
    vim.bo.filetype = "terraform"
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.tfstate",
  callback = function()
    vim.bo.filetype = "json"
  end,
})

-- Bazel filetype
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.bzl", "BUILD", "*.BUILD", "BUILD.*", "WORKSPACE", "WORKSPACE.*" },
  callback = function()
    vim.bo.filetype = "bzl"
  end,
})

-- Enable spellcheck conditionally based on filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local ft = vim.bo.filetype
    local enabled_filetypes = { "markdown", "text", "" }
    if vim.tbl_contains(enabled_filetypes, ft) or vim.fn.empty(vim.bo.filetype) ~= 0 then
      vim.wo.spell = true
    end
  end,
})

-- Global statusline (v0.7)
-- vim.cmd("set laststatus=3")
-- vim.cmd("hi WinSeparator guibg=NONE")
