local M = {}

-- BUG: https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
-- TODO: see if empty buffers bring up Dashboard instead
-- TODO: see if new buffers can be open in tabs by default

function M.setup()
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
end

function M.config()
  -- Set barbar's options
  require("bufferline").setup({
    maximum_padding = 1,
  })
end

return M
