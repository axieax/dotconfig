-- TODO: see if there is a setting for keeping cursor position despite scroll
local vim_apply = require("utils").vim_apply

-- Variables

-- Global variables
vim_apply(vim.g, {})

-- Buffer variables
vim_apply(vim.b, {})

-- Window variables
vim_apply(vim.w, {})

-- Tabpage variables
vim_apply(vim.t, {})

-- Predefined Vim variables
vim_apply(vim.v, {})

-- Environment variables
vim_apply(vim.env, {})

-- Options (:set)
vim_apply(vim.o, {
  -- General options
  mouse = "a",
  spell = true,
  scrolloff = 1,
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

  showmatch = true,
  hlsearch = true,
  incsearch = true,
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
})

-- Global options (:setglobal)
vim_apply(vim.go, {})

-- Buffer options (:setlocal for buffer-local options)
vim_apply(vim.bo, {})

-- Window options (:setlocal for window-local options)
vim_apply(vim.wo, {})

-- Misc
-- Hybrid relative numbers for normal mode, absolute for insert mode
vim.cmd([[
fun! SetRelativeNumber()
  " dashboard\|nvimtree
  if &ft =~ 'dashboard'
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
  loaded_netrw = 1, -- disables netrw
  netrw_liststyle = 3, -- tree style
  netrw_preview = 1, -- vertical splits for previews
  netrw_altv = true, -- opens vsplit to right
})

-- Auto-resize
vim.cmd("autocmd VimResized * wincmd =")

-- Apply keybindings
require("general.binds")
