local vim_apply = require("axie.utils").vim_apply

-- TODO: writebackup
-- TODO: https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
vim_apply(vim.opt, {
  -- General options
  mouse = "a",
  -- spell = true,
  scrolloff = 1,
  sidescrolloff = 2,
  whichwrap = "bs<>[]hl",
  cursorline = true,
  splitbelow = true,
  splitright = true,
  hidden = true,
  number = true,
  relativenumber = true,
  ruler = true,
  colorcolumn = "80",
  numberwidth = 1,
  -- signcolumn = "number", -- TODO: find a way to right-align symbol
  termguicolors = true,
  showmode = false,
  swapfile = false,
  undofile = true, -- persistent undo
  -- updatetime = 1500,

  list = true,
  -- NOTE: indent-blankline covers first tab character so not visible
  listchars = "tab:→ ,trail:·,extends:▶,precedes:◀,nbsp:␣",

  wildmenu = true,
  wildmode = "full",
  wildoptions = "tagfile",
  autoread = true,
  pumblend = 15,

  showmatch = true,
  hlsearch = true,
  incsearch = true, -- live search preview
  inccommand = "split", -- live substitution preview
  ignorecase = true,
  smartcase = true,
  spelllang = "en_au",

  -- Coding options
  -- https://arisweedler.medium.com/tab-settings-in-vim-1ea0863c5990
  expandtab = true,
  shiftwidth = 2,
  softtabstop = 2,
  tabstop = 2,
  autoindent = true,
  smartindent = true,
  -- cindent = true, -- fix markdown code block indents, but may randomly indent sometimes
})

-- vim.opt.cpoptions:append(">")

-- netrw settings (for directory tree view)
vim_apply(vim.g, {
  -- loaded_netrw = 1, -- disables netrw
  netrw_liststyle = 3, -- tree style
  netrw_preview = 1, -- vertical splits for previews
  netrw_altv = true, -- opens vsplit to right
})

-- NOTE: want comment continue in some cases (e.g. java(s) docstring)
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable automatic comment insertion",
  group = vim.api.nvim_create_augroup("AutoComment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Enable spellcheck conditionally based on filetypes
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Enable spellcheck",
  group = vim.api.nvim_create_augroup("SpellCheck", {}),
  callback = function()
    local ft = vim.bo.filetype
    local enabled_filetypes = { "markdown", "text", "" }
    if vim.tbl_contains(enabled_filetypes, ft) or vim.fn.empty(vim.bo.filetype) ~= 0 then
      vim.opt_local.spell = true
    end
  end,
})
