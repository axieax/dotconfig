local M = {}

-- TODO: see if new buffers can be open in tabs by default

M.keys = {
  -- Buffer navigation
  { "<Tab>", "<Cmd>BufferNext<CR>" },
  { "<S-Tab>", "<Cmd>BufferPrevious<CR>" },
  { "<A-w>", "<Cmd>BufferClose<CR>" },
  { "<A-W>", "<Cmd>BufferClose!<CR>" },
  { "<A-p>", "<Cmd>BufferPin<CR>" },

  -- Buffer shortcuts
  { "<A-;>", "<Cmd>BufferPick<CR>" },
  { "<A-1>", "<Cmd>BufferGoto 1<CR>" },
  { "<A-2>", "<Cmd>BufferGoto 2<CR>" },
  { "<A-3>", "<Cmd>BufferGoto 3<CR>" },
  { "<A-4>", "<Cmd>BufferGoto 4<CR>" },
  { "<A-5>", "<Cmd>BufferGoto 5<CR>" },
  { "<A-6>", "<Cmd>BufferGoto 6<CR>" },
  { "<A-7>", "<Cmd>BufferGoto 7<CR>" },
  { "<A-8>", "<Cmd>BufferGoto 8<CR>" },
  { "<A-9>", "<Cmd>BufferGoto 9<CR>" },
  { "<A-0>", "<Cmd>BufferLast<CR>" },

  -- Buffer re-order / sort
  { "<A-,>", "<Cmd>BufferMovePrevious<CR>" },
  { "<A-.>", "<Cmd>BufferMoveNext<CR>" },
  { "<Leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>" },
  { "<Leader>bd", "<Cmd>BufferOrderByDirectory<CR>" },
  { "<Leader>bl", "<Cmd>BufferOrderByLanguage<CR>" },
  { "<Leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>" },
}

M.opts = { maximum_padding = 1 }

return M
