local map = require("utils").map

-- Set leader key
-- vim.g.mapleader = ","

-- Terminal normal mode
-- map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Source
-- vim.cmd("command! R :luafile $MYVIMRC<CR>:PackerCompile<CR>")
vim.cmd("command! R :luafile $MYVIMRC<CR>")

-- Move line(s) up/down
map({ "n", "<A-j>", ":move .+2<CR>==" })
map({ "n", "<A-k>", ":move .-1<CR>==" })
map({ "v", "<A-j>", ":move '>+2<CR>gv=gv" })
map({ "v", "<A-k>", ":move '<-1<CR>gv=gv" })

-- Duplicate line(s)
map({ "n", "<A-d>", ":co .<CR>==" })
map({ "v", "<A-d>", ":co '><CR>gv=gv" })

-- Select all
map({ "n", "<c-a>", "ggVG" })
-- map({ "n", "<C-A>", "<cmd>%+y<CR>" })
