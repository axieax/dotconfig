-- Terminal normal mode
-- map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Move line(s)
map("n", "<A-k>", ":move -2<CR>==")
map("n", "<A-j>", ":move +1<CR>==")

-- Duplicate line(s)
map("n", "<A-d>", ":co.")

-- TODO: fold function

