local map = require('utils').map

-- Set leader key
-- vim.g.mapleader = ","

-- Terminal normal mode
-- map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Source
vim.cmd("command! R :luafile $MYVIMRC")

-- Move line(s) up/down
map({"n", "<A-j>", ":move .+1<CR>=="})
map({"n", "<A-k>", ":move .-2<CR>=="})
map({"v", "<A-j>", ":move '>+1<CR>gv=gv"})
map({"v", "<A-k>", ":move '<-2<CR>gv=gv"})

-- Duplicate line(s)
map({"n", "<A-d>", ":co .<CR>=="})
map({"v", "<A-d>", ":co '><CR>gv=gv"})

