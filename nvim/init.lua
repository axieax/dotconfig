-- Automatically PackerCompile whenever plugins are updated

-- Load settings
-- require('utils')
-- require('utils.config')
require('general')
require('plugins')
-- -- Need better Vim event since currently this may result in an infinite loop
-- -- BUG: calling LspInstall brings up another prompt (buffer)..
-- vim.cmd("autocmd BufEnter * lua auto_lsp_install()")

