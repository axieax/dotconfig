local M = {}

function M.setup()
  vim.keymap.set("n", "\\<Tab>", "<Cmd>SymbolsOutline<CR>", { desc = "symbols outline" })
  vim.keymap.set("n", "<Space><S-Tab>", "<Cmd>SymbolsOutline<CR>", { desc = "symbols outline" })
end

function M.config()
  require("symbols-outline").setup({
    -- highlight_hovered_item = false,
    auto_close = true,
    auto_preview = false,
    -- instant_preview = true,
    border = "rounded",
    winblend = 15,
  })
end

return M
