local filetype_map = require("axie.utils").filetype_map
local map = vim.keymap.set

map("n", "K", vim.lsp.buf.hover)

map("n", "<Space>w", "<Cmd>update<CR>")

-- Wrapped cursor navigation
for _, key in ipairs({ "j", "k" }) do
  map({ "n", "x" }, key, function()
    return vim.v.count > 0 and key or "g" .. key
  end, { desc = "Wrapped lines cursor navigation with " .. key, expr = true })
end

map("x", ".", ":norm.<CR>", { desc = "visual mode dot repeat" })
map("x", "Q", function()
  local register = vim.fn.nr2char(vim.fn.getchar()) -- get register from user
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(":normal @" .. register .. "<CR>", true, false, true))
end, { desc = "Apply normal macro over visual selection" })

-- Center search result jumps
local center_keys = { "n", "N", "{", "}", "*", "[g", "]g", "[s", "]s", "[m", "]m" }
for _, key in ipairs(center_keys) do
  map("n", key, key .. "zz", { desc = "Centred " .. key })
end

-- Resize windows
map("n", "<C-w>K", "<Cmd>resize -1<CR>")
map("n", "<C-w>J", "<Cmd>resize +1<CR>")
map("n", "<C-w>H", "<Cmd>vertical resize -1<CR>")
map("n", "<C-w>L", "<Cmd>vertical resize +1<CR>")
map("n", "H", "<Cmd>vertical resize -1<CR>")
map("n", "L", "<Cmd>vertical resize +1<CR>")

-- Visual indent
map("v", "<", "<gv")
map("v", ">", ">gv")

map("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })
map("n", "<Space>e", "<Cmd>edit<CR>", { desc = "Refresh buffer" })
map("n", "<Space>c", function()
  require("axie.utils").display_path()
end, { desc = "Display file path" })
map("n", "<Space>C", function()
  require("axie.utils").display_path()
end, { desc = "Display cwd" })
map("n", "<Space>p", ":lua =", { desc = "Lua print", silent = false })
map("n", "<Space>P", ":lua require'axie.utils'.notify()<LEFT>", { desc = "Lua notify", silent = false })

local yank_register = vim.loop.os_uname().sysname == "Linux" and "+" or "*"
map({ "n", "v" }, "\\y", '"' .. yank_register .. "y", { desc = "Yank to clipboard" })
map("n", "\\+", '<Cmd>let @+=@"<CR>', { desc = "Copy yank register to clipboard" })
map({ "n", "v" }, "\\p", '"0p', { desc = "Paste last yanked" })

-- Filetype-specific
filetype_map("markdown", "v", ",*", "S*gvS*", { remap = true, desc = "Bold selection" })
filetype_map("sh", "n", ",x", "<Cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- CHECK: https://github.com/neovim/neovim/issues/14090#issuecomment-1113090354
map("n", "<C-i>", "<C-i>")
