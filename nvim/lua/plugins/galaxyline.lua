-- https://github.com/glepnir/galaxyline.nvim --
-- TODO: gap at beginning and end
-- File indent size?
-- https://github.com/glepnir/galaxyline.nvim/issues/12#issuecomment-771211490

return function()
	local colours = require('galaxyline.theme').default
	-- LEFT --
	-- Mode
	require('galaxyline').section.left[1] = {
		ViMode = {
			provider = function ()
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
	}
	
	require('galaxyline').section.left[2] = {
		GitBranch = {
			provider = "GitBranch",
			icon = "  ",
		}
	}

	require('galaxyline').section.left[3] = {
		DiffAdd = {
			provider = "DiffAdd",
			icon = "  ",
		}
	}

	require('galaxyline').section.left[4] = {
		DiffModified = {
			provider = "DiffModified",
			icon = "  ",
		}
	}

	require('galaxyline').section.left[5] = {
		DiffRemove = {
			provider = "DiffRemove",
			icon = "  ",
		}
	}



	require('galaxyline').section.mid[1] = {
		DiagnosticError = {
			provider = "DiagnosticError",
			icon = "  ",
		},
	}

	require('galaxyline').section.mid[2] = {
		DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = "  ",
		},
	}

	require('galaxyline').section.mid[3] = {
		DiagnosticHint = {
			provider = "DiagnosticHint",
			icon = "  ",
		},
	}

	require('galaxyline').section.mid[4] = {
		DiagnosticInfo = {
			provider = "DiagnosticInfo",
			icon = "  ",
		},
	}


	require('galaxyline').section.right[1] = {
		FileIcon = {
			provider = "FileIcon"
		}
	}

	require('galaxyline').section.right[2] = {
		LspClient = {
			provider = "GetLspClient"
		}
	}

	require('galaxyline').section.right[3] = {
		FileSize = {
			provider = "FileSize",
			separator = " "
		}
	}

	require('galaxyline').section.right[4] = {
		LineColumn = {
			provider = "LineColumn",
			separator = " "
		}
	}

	require('galaxyline').section.right[5] = {
		ScrollBar = {
			provider = "ScrollBar",
			separator = " "
		}
	}

	-- Just a whitespace
	-- require('galaxyline').section.right[4] = {
	-- 	Whitespace = {
	-- 		provider = "Whitespace"
	-- 	}
	-- }

	-- -- https://github.com/liuchengxu/vista.vim
	-- require('galaxyline').section.right[4] = {
	-- 	VistaPlugin = {
	-- 		provider = "VistaPlugin"
	-- 	}
	-- }


end
