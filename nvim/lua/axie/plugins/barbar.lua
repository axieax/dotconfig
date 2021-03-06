-- https://github.com/romgrk/barbar.nvim --
-- BUG: https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
-- TODO: see if empty buffers bring up Dashboard instead
-- TODO: see if new buffers can be open in tabs by default

return function()
  -- Buffer navigation
  vim.keymap.set("n", "<TAB>", "<Cmd>BufferNext<CR>")
  vim.keymap.set("n", "<S-TAB>", "<Cmd>BufferPrevious<CR>")
  vim.keymap.set("n", "<A-w>", "<Cmd>BufferClose<CR>")
  vim.keymap.set("n", "<A-W>", "<Cmd>BufferClose!<CR>")
  vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>")

  -- Buffer shortcuts
  vim.keymap.set("n", "<A-;>", "<Cmd>BufferPick<CR>")
  vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>")
  vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>")
  vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>")
  vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>")
  vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>")
  vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>")
  vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>")
  vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>")
  vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>")
  vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>")

  -- Buffer re-order / sort
  vim.keymap.set("n", "<A-,>", "<Cmd>BufferMovePrevious<CR>")
  vim.keymap.set("n", "<A-.>", "<Cmd>BufferMoveNext<CR>")
  vim.keymap.set("n", "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>")
  vim.keymap.set("n", "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>")
  vim.keymap.set("n", "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>")
  vim.keymap.set("n", "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>")

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
    icon_separator_active = "???",
    icon_separator_inactive = "???",
    icon_close_tab = "???",
    icon_close_tab_modified = "???",
    icon_pinned = "???",

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
    letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

    -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = nil,
  }
end
