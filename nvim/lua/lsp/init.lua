-- LSP scripts --
local M = {}

-------------
-- Helpers --
-------------
local lsp_install = require('lspinstall')
local installed_servers = lsp_install.installed_servers()
local available_servers = lsp_install.available_servers()

local is_installable_language = function(language)
	-- Check if language is already installed
	for _, installed_language in pairs(installed_servers) do
		if installed_language == language then
			return false
		end
	end
	-- Check if language is available
	for _, available_language in pairs(available_servers) do
		if available_language == language then
			return true
		end
	end
	return false
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
		-- print("Please type :LspInstall "..language)
		-- vim.cmd("LspInstall " .. language)
	end
end

return M

