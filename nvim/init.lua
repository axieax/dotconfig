-- Automatically PackerCompile whenever plugins are updated

-- Load settings
require('utils')
require('general')
require('plugins')
vim.cmd("autocmd BufEnter * lua auto_lsp_install()")

