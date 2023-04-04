local M = {}

M.keys = {
  { "<Space>lI", "<Cmd>Mason<CR>", desc = "LSP installer" },
  { "<Space>lU", "<Cmd>MasonToolsUpdate<CR>", desc = "Update Mason tools" },
}

function M.config()
  -- setup lspconfig
  require("mason").setup()
  require("mason-lspconfig").setup()

  -- auto install
  local ensure_installed = require("axie.plugins.lsp.setup").ensure_installed
  local null_ensure_installed = require("axie.plugins.lsp.null").ensure_installed
  vim.list_extend(ensure_installed, null_ensure_installed)

  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
    auto_update = false,
    run_on_start = true,
  })
end

return M
