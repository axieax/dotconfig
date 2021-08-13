-- https://github.com/romgrk/barbar.nvim --
-- BUG: https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
-- TODO: see if empty buffers bring up Dashboard instead
-- TODO: see if new buffers can be open in tabs by default

return function()
	local map = require('utils').map
	-- Buffer navigation
	map({"n", "<TAB>", ":BufferNext<CR>"})
	map({"n", "<S-TAB>", ":BufferPrevious<CR>"})
	map({"n", "<A-w>", ":BufferClose<CR>"})
	map({"n", "<A-W>", ":BufferClose!<CR>"})
	map({"n", "<A-p>", ":BufferPin<CR>"})

	-- Buffer shortcuts
	map({"n", "<A-;>", ":BufferPick<CR>"})
	map({"n", "<A-1>", ":BufferGoto 1<CR>"})
	map({"n", "<A-2>", ":BufferGoto 2<CR>"})
	map({"n", "<A-3>", ":BufferGoto 3<CR>"})
	map({"n", "<A-4>", ":BufferGoto 4<CR>"})
	map({"n", "<A-5>", ":BufferGoto 5<CR>"})
	map({"n", "<A-6>", ":BufferGoto 6<CR>"})
	map({"n", "<A-7>", ":BufferGoto 7<CR>"})
	map({"n", "<A-8>", ":BufferGoto 8<CR>"})
	map({"n", "<A-9>", ":BufferGoto 9<CR>"})
	map({"n", "<A-0>", ":BufferLast<CR>"})

	-- Buffer re-order / sort
	map({"n", "<A-,>", ":BufferMovePrevious<CR>"})
	map({"n", "<A-.>", ":BufferMoveNext<CR>"})
	map({"n", "<leader>bb", ":BufferOrderByBufferNumber<CR>"})
	map({"n", "<leader>bd", ":BufferOrderByDirectory<CR>"})
	map({"n", "<leader>bl", ":BufferOrderByLanguage<CR>"})
	map({"n", "<leader>bw", ":BufferOrderByWindowNumber<CR>"})

	-- Set barbar's options
	vim.g.bufferline = {
		-- Enable/disable animations
		animation = true,

		-- Enable/disable auto-hiding the tab bar when there is a single buffer
		auto_hide = false,

		-- Enable/disable current/total tabpages indicator (top right corner)
		tabpages = true,

		-- Enable/disable close button
		closable = true,

		-- Enables/disable clickable tabs
		--  - left-click: go to buffer
		--  - middle-click: delete buffer
		clickable = true,

		-- Excludes buffers from the tabline
		exclude_ft = {},
		exclude_name = {},

		-- Enable/disable icons
		-- if set to 'numbers', will show buffer index in the tabline
		-- if set to 'both', will show buffer index and icons in the tabline
		icons = true,

		-- If set, the icon color will follow its corresponding buffer
		-- highlight group. By default, the Buffer*Icon group is linked to the
		-- Buffer* group (see Highlighting below). Otherwise, it will take its
		-- default value as defined by devicons.
		icon_custom_colors = false,

		-- Configure icons on the bufferline.
		icon_separator_active = '▎',
		icon_separator_inactive = '▎',
		icon_close_tab = '',
		icon_close_tab_modified = '●',
		icon_pinned = '車',

		-- If true, new buffers will be inserted at the end of the list.
		-- Default is to insert after current buffer.
		insert_at_end = false,

		-- Sets the maximum padding width with which to surround each tab
		maximum_padding = 1,

		-- Sets the maximum buffer name length.
		maximum_length = 30,

		-- If set, the letters for each buffer in buffer-pick mode will be
		-- assigned based on their name. Otherwise or in case all letters are
		-- already assigned, the behavior is to assign letters in order of
		-- usability (see order below)
		semantic_letters = true,

		-- New buffer letters are assigned in this order. This order is
		-- optimal for the qwerty keyboard layout but might need adjustement
		-- for other layouts.
		letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

		-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
		-- where X is the buffer number. But only a static string is accepted here.
		no_name_title = nil,
	}
end

