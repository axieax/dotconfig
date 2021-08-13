local map = require('utils').map

-- Set leader key
-- vim.g.mapleader = ","

-- Terminal normal mode
-- map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Source
vim.cmd("command! R :luafile $MYVIMRC")

-- Move line - NOTE: doesn't work for multiple lines
map({"n", "<A-k>", ":move -2<CR>=="})
map({"n", "<A-j>", ":move +1<CR>=="})

-- Duplicate line(s)
map({"n", "<A-d>", ":co."})

-- TODO: fold function

