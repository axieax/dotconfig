local M = {}

-- Default languages/technologies required to be setup
-- TODO: lsp install and treesitter parse
-- NOTE: other languages should be lazily installed
M.prepared_languages = {
	-- Scripting
	'python',
	'lua',
	'bash',
	-- Web development
	'html',
	'css',
	'scss',
	'javascript',
	'typescript',
	'jsx',
	'tsx',
	'json',
	'jsonc',
	'dockerfile',
	-- Misc
	'c',
	'cpp',
	'regex',
}

-- Icons
M.lsp_diagnostics_icons = {
	Error = "",
	Warning = "",
	Hint = "",
	Information = "",
	VirtualText = "",
}

-- Colourscheme?

return M
