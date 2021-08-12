-- LSP scripts --
local M = {}

-------------
-- Helpers --
-------------
local lsp_install = require('lspinstall')
local installed_servers = lsp_install.installed_servers()
local available_servers = lsp_install.available_servers()

local is_installable_language = function(language)
	return installed_servers[language] == nil and available_servers[language] ~= nil
end

---------------------------
-- Pre-install languages --
---------------------------
local pre_install_languages = {
	'python',
}

M.pre_install = function()
	for _, language in pairs(pre_install_languages) do
		if is_installable_language(language) then
			lsp_install.install_server(language)
		end
	end
end

----------------------------
-- Auto-install languages --
----------------------------
_G.auto_lsp_install = function()
	local language = vim.bo.filetype
	if is_installable_language(language) then
		vim.cmd("LspInstall " .. language)
	end
end

return M

