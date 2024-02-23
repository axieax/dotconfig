local M = {}

M.keys = {
  {
    -- ALT: <C-t>
    "<Tab>",
    function()
      require("autolist").tab()
    end,
    mode = "i",
    desc = "Autolist tab",
  },
  {
    -- ALT: <C-d>
    "<S-Tab>",
    function()
      require("autolist").shift_tab()
    end,
    mode = "i",
    desc = "Autolist shift tab",
  },
  {
    "<C-r>",
    function()
      require("autolist").recalculate()
    end,
    mode = "i",
    desc = "Autolist recalculate",
  },
  {
    "\\[",
    function()
      require("autolist").cycle_prev_dr()
    end,
    mode = "n",
    expr = true,
    desc = "Autolist cycle list type (prev)",
  },
  {
    "\\]",
    function()
      require("autolist").cycle_next_dr()
    end,
    mode = "n",
    expr = true,
    desc = "Autolist cycle list type (next)",
  },
  {
    "<CR>",
    function()
      require("autolist").toggle_checkbox()
    end,
    mode = "n",
    desc = "Autolist toggle checkbox",
  },
}

function M.config()
  local autolist = require("autolist")
  autolist.setup()

  -- vim.keymap.set("i", "<c-t>", "<c-t><Cmd>AutolistRecalculate<CR>") -- an example of using <c-t> to indent
  vim.keymap.set("i", "<CR>", "<CR><Cmd>AutolistNewBullet<CR>")
  vim.keymap.set("n", "o", "o<Cmd>AutolistNewBullet<CR>")
  vim.keymap.set("n", "O", "O<Cmd>AutolistNewBulletBefore<CR>")

  -- functions to recalculate list on edit
  vim.keymap.set("n", ">>", ">><Cmd>AutolistRecalculate<CR>")
  vim.keymap.set("n", "<<", "<<<Cmd>AutolistRecalculate<CR>")
  vim.keymap.set("n", "dd", "dd<Cmd>AutolistRecalculate<CR>")
  vim.keymap.set("v", "d", "d<Cmd>AutolistRecalculate<CR>")
end

return M
