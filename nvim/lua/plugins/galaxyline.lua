-- https://github.com/glepnir/galaxyline.nvim --
-- TODO: insert control characters for block modes
-- https://elianiva.my.id/post/neovim-lua-statusline
-- TODO: gap at beginning and end
-- File indent size?
-- https://github.com/glepnir/galaxyline.nvim/issues/12#issuecomment-771211490
-- TODO: venv
-- TODO: icon only to indicate LSP active?
-- TODO: group linecol and percentage ()

return function()
	local lsp_diagnostics_icons = require("utils.config").lsp_diagnostics_icons

	local colours = require('galaxyline.theme').default
	local section = require('galaxyline').section
	-- LEFT --
	section.left = {
		{
			ViMode = {
				provider = function()
					local modes = {
						-- Normal
						n = { "Normal", colours.violet },
						no = { "Operator Pending", colours.violet },
						-- Insert
						i = { "Insert", colours.yellow },
						-- Visual
						v = { "Visual", colours.magenta },
						V = { "Visual Line", colours.magenta },
						[""] = { "Visual Block" , colours.magenta },
						-- Select
						s = { "Select", colours.blue },
						S = { "Select Line", colours.blue },
						[""] = { "Select Block", colours.blue },
						-- Replace
						R = { "Replace", colours.red },
						Rv = { "Virtual Replace", colours.red },
						-- Exec
						c = { "Command", colours.orange },
						cv = { "Vim Ex", colours.green },
						ce = { "Normal Ex", colours.green },
						r = { "Hit-Enter Prompt", colours.cyan },
						rm = { "More Prommpt", colours.cyan },
						["r?"] = { "Confirm Query", colours.green },
						["!"] = { "Shell", colours.orange },
						t = { "Terminal", colours.green },
					}
					local mode_abbrev = vim.fn.mode()
					-- local mode_abbrev = vim.api.nvim_get_mode().mode
					local mode_text = "Unknown: " .. mode_abbrev
					local mode_colour = colours.red

					local mode = modes[mode_abbrev]
					if mode ~= nil then
						mode_text = mode[1]
						mode_colour = mode[2]
					end

					vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_colour)
					return mode_text
				end,
				icon = '  ',
				-- highlight = { colours.green, colours.purple },
				separator = ' ',
				-- separator_highlight = { colours.purple, colours.darkblue },
			}
		},
		{
			GitBranch = {
				provider = "GitBranch",
				icon = "  ",
			}
		},
		{
			DiffAdd = {
				provider = "DiffAdd",
				icon = "  ",
			}
		},
		{
			DiffModified = {
				provider = "DiffModified",
				icon = "  ",
			}
		},
		{
			DiffRemove = {
				provider = "DiffRemove",
				icon = "  ",
			}
		},
	}


	section.mid = {
		{
			DiagnosticError = {
				provider = "DiagnosticError",
				icon = " " .. lsp_diagnostics_icons.Error .. " ",
			}
		},
		{
			DiagnosticWarn = {
				provider = "DiagnosticWarn",
				icon = " " .. lsp_diagnostics_icons.Warning .. " ",
			}
		},
		{
			DiagnosticHint = {
				provider = "DiagnosticHint",
				icon = " " .. lsp_diagnostics_icons.Hint .. " ",
			}
		},
		{
			DiagnosticInfo = {
				provider = "DiagnosticInfo",
				icon = " " .. lsp_diagnostics_icons.Information .. " ",
			}
		}
	}

	section.right = {
		{
			FileIcon = {
				provider = "FileIcon"
			}
		},
		{
			LspClient = {
				provider = "GetLspClient"
			}
		},
		{
			FileSize = {
				provider = "FileSize",
				separator = " "
			}
		},
		{
			LineColumn = {
				provider = "LineColumn",
				separator = " "
			}
		},
		{
			ScrollBar = {
				provider = "ScrollBar",
				separator = " "
			}
		},
	}


	-- Just a whitespace
	-- {w = {provider = "WhiteSpace", separator = " "}},

	-- -- https://github.com/liuchengxu/vista.vim
	-- section.right[4] = {
	-- 	VistaPlugin = {
	-- 		provider = "VistaPlugin"
	-- 	}
	-- }

end
