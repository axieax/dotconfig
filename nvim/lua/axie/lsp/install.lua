local M = {}

function M.setup()
  -- setup lspconfig
  require("mason").setup()
  require("mason-lspconfig").setup()

  -- auto install
  local ensure_installed = require("axie.lsp.setup").ensure_installed
  local null_ensure_installed = require("axie.lsp.null").ensure_installed
  vim.list_extend(ensure_installed, null_ensure_installed)

  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
    auto_update = false,
    run_on_start = true,
  })

  -- setup language servers
  require("axie.lsp.setup").servers()
end

return M
