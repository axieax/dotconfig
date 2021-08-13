-- https://github.com/neovim/nvim-lspconfig --

return function()
	local map = require('utils').map
	local lsp_diagnostics_icons = require("utils.config").lsp_diagnostics_icons

	-- Keymaps (see `:help vim.lsp.*`)
	map({'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'})
	map({'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>'})
	map({'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>'})
	map({'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>'})
	map({'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'})
	map({'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'})
	map({'n', 'gp', '<cmd>lua vim.lsp.buf.formatting()<CR>'})

	-- TODO: quick fix?
	map({'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>'})
	map({'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>'})
	map({'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'})
	map({'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'})
	map({'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'})
	map({'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'})
	map({'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'})

	map({'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'})
	map({'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'})
	map({'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'})

	-- Gutter diagnostic symbols
	for type, icon in pairs(lsp_diagnostics_icons) do
		local hl = "LspDiagnosticsSign" .. type
		vim.fn.sign_define(hl,	{ text = icon, texthl = hl, numhl = hl })
	end

	-- Diagnostic virtual text
	vim.lsp.handlers["textDocument/publishDiagnostics"] =
	function(_, _, params, client_id, _)
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

	-- Completion types
	vim.lsp.protocol.CompletionItemKind = {
		'  ', -- Text
		'  ', -- Method
		'  ', -- Function
		'  ', -- Constructor
		' ﴲ ', -- Field
		'[]', -- Variable
		'  ', -- Class
		' ﰮ ', -- Interface
		'  ', -- Module
		' 襁', -- Property
		'  ', -- Unit
		'  ', -- Value
		' 練', -- Enum
		'  ', -- Keyword
		'  ', -- Snippet
		'  ', -- Colour
		'  ', -- File
		'  ', -- Reference
		'  ', -- Folder
		'  ', -- EnumMember
		' ﲀ ', -- Constant
		' ﳤ ', -- Struct
		'  ', -- Event
		'  ', -- Operator
		'  ', -- TypeParameter
	}

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

