-- https://github.com/neovim/nvim-lspconfig --
-- TODO: filter/sort severity?
-- Highlight line number instead of icons (https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#highlight-line-number-instead-of-having-icons-in-sign-column)

return function()
  local lsp_diagnostics_icons = require("utils.config").lsp_diagnostics_icons

  -- Gutter diagnostic symbols
  for type, icon in pairs(lsp_diagnostics_icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = lsp_diagnostics_icons.VirtualText,
      spacing = 4,
      source = "always",
      format = function(diagnostic)
        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
      end,
    },
    signs = true,
    underline = true,
    update_in_insert = true,
  })

  -- Diagnostic source
  vim.diagnostic.config({
    float = { source = "always" },
  })
end
