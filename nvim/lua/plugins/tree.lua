-- https://github.com/preservim/nerdtree --
return function()
	-- TODO: autohide when entered (toggle)?
	-- NOTE: to get devicons, need a different devicons plugin
	-- TODO: Git status plugin

	local utils = require("utils")

	utils.vim_apply(vim.g, {
		NERDTreeWinPos = "right",
	})

	utils.map({"n", ";", "<cmd>NERDTreeToggle<CR>"})

end
