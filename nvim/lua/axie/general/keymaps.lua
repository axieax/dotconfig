local utils = require("axie.utils")
local filetype_map = utils.filetype_map
local restore_position_wrap = utils.restore_position_wrap
local map = vim.keymap.set

map("n", "K", vim.lsp.buf.hover)

map("n", "<Space>w", "<Cmd>update<CR>", { desc = "Update" })

-- Wrapped cursor navigation
for _, key in ipairs({ "j", "k" }) do
  map({ "n", "x" }, key, function()
    return vim.v.count > 0 and key or "g" .. key
  end, { desc = "Wrapped lines cursor navigation with " .. key, expr = true })
end

map("x", ".", ":norm.<CR>", { desc = "Visual mode dot repeat" })
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

map("n", "<Space>q", "<Cmd>copen<CR>", { desc = "Quickfix list" })
map("n", "<Space>Q", "<Cmd>lopen<CR>", { desc = "Location list" })
map("n", "<Space>fs", "1z=", { desc = "Correct spelling" })
map("n", "<Space>fS", "z=", { desc = "Spelling suggestions", remap = true })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })
map("n", "<Space>e", "<Cmd>edit<CR>", { desc = "Refresh buffer" })
map("n", "<Space>c", function()
  require("axie.utils").display_path()
end, { desc = "Display file path" })
map("n", "<Space>C", function()
  require("axie.utils").display_cwd()
end, { desc = "Display cwd" })
map("n", "<Space>i", "<Cmd>Inspect<CR>")
map("n", "<Space>I", "<Cmd>InspectTree<CR>")
map("n", "<Space>p", ":=", { desc = "Lua print", silent = false })
map("n", "<Space>P", ":lua require'axie.utils'.notify()<LEFT>", { desc = "Lua notify", silent = false })
map("n", "<Space>v", "ggVG", { desc = "Select all" })
map(
  "n",
  "<Space>V",
  restore_position_wrap(function()
    vim.api.nvim_cmd({
      cmd = "normal",
      bang = true,
      args = { 'ggVG"+y' },
    }, {})
  end),
  { desc = "Copy all to clipboard" }
)

-- tpope/unimpaired has [<Space> and ]<Space> as well
map("n", "\\o", "o<Esc>", { desc = "Create new line below" })
map("n", "\\O", "O<Esc>", { desc = "Create new line above" })
map("n", "\\s", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle spell" })

local signcolumn_enabled = true
map("n", "\\l", function()
  vim.o.signcolumn = signcolumn_enabled and "no" or "auto"
  signcolumn_enabled = not signcolumn_enabled
end, { desc = "Toggle signcolumn" })

--- Replace text-object with yanked content
---@param paste_cmd string @command for pasting
local function paste_replace(paste_cmd)
  local prev_func = vim.go.operatorfunc
  -- selene: allow(global_usage)
  _G.paste_replace = function()
    vim.api.nvim_feedkeys("`[v`]" .. paste_cmd, "n", true)
    vim.go.operatorfunc = prev_func
    _G.paste_replace = nil
  end
  vim.go.operatorfunc = "v:lua.paste_replace"
  vim.api.nvim_feedkeys("g@", "n", false)
end

map("n", "\\r", function()
  paste_replace("p")
end, { desc = "Replace with yanked" })
map("n", "\\R", function()
  paste_replace("\\p")
end, { desc = "Replace with last yanked" })
map("n", "\\c", '"_c', { desc = "Change (no register)" })
map("n", "\\C", '"_C', { desc = "Change (no register)" })

map(
  "n",
  "gQ",
  restore_position_wrap(function()
    vim.api.nvim_cmd({
      cmd = "normal",
      args = { "ggVGgq" },
    }, {})
  end),
  { desc = "Format buffer" }
)

map(
  "n",
  "\\,",
  restore_position_wrap(function()
    vim.api.nvim_cmd({
      cmd = "normal",
      args = { "A," },
    }, {})
  end),
  { desc = "Add trailing comma" }
)
map(
  "v",
  "\\,",
  ":'<,'>norm A,<CR>", -- TODO: restore_position_wrap
  { desc = "Add trailing commas" }
)

map(
  "n",
  "\\;",
  restore_position_wrap(function()
    vim.api.nvim_cmd({
      cmd = "normal",
      args = { "A;" },
    }, {})
  end),
  { desc = "Add trailing semicolon" }
)
map(
  "v",
  "\\,",
  ":'<,'>norm A;<CR>", -- TODO: restore_position_wrap
  { desc = "Add trailing semicolons" }
)

map({ "n", "v" }, "\\y", '"+y', { desc = "Yank to clipboard" })
map("n", "\\+", '<Cmd>let @+=@"<CR>', { desc = "Copy yank register to clipboard" })
map({ "n", "v" }, "\\p", '"0p', { desc = "Paste last yanked" })

map("i", "<A-t>", "<C-v><Tab>", { desc = "Insert tab" })

-- Filetype-specific
filetype_map("markdown", "v", ",*", "S*gvS*", { remap = true, desc = "Bold selection" })
filetype_map("json", "n", ",c", function()
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  vim.api.nvim_buf_set_option(buf, "filetype", filetype == "json" and "jsonc" or "json")
end, { desc = "Toggle jsonc filetype" })
filetype_map("sh", "n", ",x", "<Cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- CHECK: https://github.com/neovim/neovim/issues/14090#issuecomment-1113090354
map("n", "<C-i>", "<C-i>")
