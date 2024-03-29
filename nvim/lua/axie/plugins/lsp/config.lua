local M = {}

-- TODO: filter/sort severity?
-- Highlight line number instead of icons (https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#highlight-line-number-instead-of-having-icons-in-sign-column)

M.keys = {
  { "<Space>l?", "<Cmd>LspInfo<CR>" },
  { "<Space>lR", "<Cmd>LspRestart<CR>" },
}

function M.config()
  local diagnostics_icons = require("axie.utils.config").diagnostics_icons

  -- Gutter diagnostic symbols
  for type, icon in pairs(diagnostics_icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = diagnostics_icons.VirtualText,
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

  -- Hover rounded borders with transparent background
  local function customise_handler(handler)
    local overrides = { border = "rounded" }
    return vim.lsp.with(function(...)
      local _, winnr = handler(...)
      if winnr then
        vim.api.nvim_win_set_option(winnr, "winblend", 20)
      end
    end, overrides)
  end

  vim.lsp.handlers["textDocument/hover"] = customise_handler(vim.lsp.handlers.hover)
  vim.lsp.handlers["textDocument/signatureHelp"] = customise_handler(vim.lsp.handlers.signature_help)

  -- LspInfo rounded borders
  require("lspconfig.ui.windows").default_options.border = "rounded"
  vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })

  -- Code actions lightbulb
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LightbulbSetup", {}),
    callback = require("axie.plugins.lsp.code_actions").setup_lightbulb,
  })
end

return M
