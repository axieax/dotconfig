local vim_apply = require("axie.utils").vim_apply
local map = require("axie.utils").map
local ternary = require("axie.utils").ternary

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
vim.cmd([[
fun! SetRelativeNumber()
  " dashboard\|nvimtree
  if &ft =~ 'alpha'
    return
  endif
  set relativenumber
endfun

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * call SetRelativeNumber()
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
]])

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

-- Paste last yanked
map({ "n", "\\p", '"0p' })
map({ "v", "\\p", '"0p' })

-- Auto-resize
vim.cmd("autocmd VimResized * wincmd =")

-- Highlight yank
vim.cmd([[
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
]])

-- Update (instead of write)
map({ "n", "<space>w", "<CMD>up<CR>" })

-- No autoformat write
vim.cmd("command! W :noautocmd w")
vim.cmd("command! Wq :noautocmd wq")
-- nvim_add_user_command("W", "noautocmd w")
-- nvim_add_user_command("Wq", "noautocmd wq")

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
vim.cmd("au BufEnter *.terraformrc,*.terraform.rc setlocal filetype=terraform")
vim.cmd("au BufEnter *.tfstate setlocal filetype=json")

-- Bazel filetype
vim.cmd("au BufEnter *.bzl,BUILD,*.BUILD,BUILD.*,WORKSPACE,WORKSPACE.* setlocal filetype=bzl")

-- Enable spellcheck conditionally based on filetypes
vim.cmd([[
augroup spellcheck
  autocmd!
  au FileType markdown,text,'' setlocal spell
  au BufEnter * if empty(&filetype) | setlocal spell | endif
augroup END
]])
