-- https://github.com/neovim/nvim-lspconfig --
-- TODO: Toggle Diagnostics (https://www.reddit.com/r/neovim/comments/ng0dj0/lsp_diagnostics_query_is_there_an_way_to_toggle/)

return function()
  local lsp_diagnostics_icons = require("utils.config").lsp_diagnostics_icons

  -- Gutter diagnostic symbols
  for type, icon in pairs(lsp_diagnostics_icons) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, _, params, client_id, _)
    local config = {
      underline = true,
      virtual_text = {
        prefix = lsp_diagnostics_icons.VirtualText,
        spacing = 4,
      },
      signs = true,
      update_in_insert = false,
    }
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics

    for i, v in ipairs(diagnostics) do
      diagnostics[i].message = string.format("%s [%s]", v.message, v.source)
    end

    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
  end

  -- Print diagnostics in status line
  -- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  -- 	opts = opts or {}

  -- 	bufnr = bufnr or 0
  -- 	line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  -- 	local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  -- 	if vim.tbl_isempty(line_diagnostics) then return end

  -- 	local diagnostic_message = ""
  -- 	for i, diagnostic in ipairs(line_diagnostics) do
  -- 		diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
  -- 		print(diagnostic_message)
  -- 		if i ~= #line_diagnostics then
  -- 			diagnostic_message = diagnostic_message .. "\n"
  -- 		end
  -- 	end
  -- 	vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
  -- end

  -- vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

  -- Show line diagnostics automatically in hover window
  -- You will likely want to reduce updatetime which affects CursorHold
  -- note: this setting is global and should be set only once
  -- vim.o.updatetime = 250
  -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]
  -- NOTE: Can LSPSaga do this?
end
