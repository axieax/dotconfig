local default_folds = require("axie.utils.config").default_folds
local vim_apply = require("axie.utils").vim_apply

-- TODO: https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
-- Grouped by :options
vim_apply(vim.opt, {
  -- 2 moving around, searching and patterns
  whichwrap = "bs<>[]hl",
  incsearch = true, -- live search preview
  inccommand = "split", -- live substitution preview
  ignorecase = true,
  smartcase = true,

  -- 4 displaying text
  scrolloff = 1,
  sidescrolloff = 2,
  -- NOTE: pretty-fold configures the `fold` fillchar
  fillchars = { foldclose = "", foldopen = "", foldsep = " " },
  list = true,
  -- NOTE: indent-blankline covers first tab character so not visible
  listchars = { tab = "→ ", trail = "·", extends = "▶", precedes = "◀", nbsp = "␣" },
  number = true,
  relativenumber = true,
  numberwidth = 1,

  -- 5 syntax, highlighting and spelling
  hlsearch = true,
  termguicolors = true,
  cursorline = true,
  -- cursorcolumn = true,
  colorcolumn = "80",
  -- spell = true,
  spelllang = "en_au",

  -- 6 multiple windows
  laststatus = 3,
  hidden = true,
  splitbelow = true,
  splitright = true,
  pumblend = 15,

  -- 9 using the mouse
  mouse = "a",
  mousemodel = "extend",

  -- 11 messages and info
  showmode = false,
  ruler = true,

  -- 13 editing text
  undofile = true, -- persistent undo
  completeopt = { "menu", "menuone", "noselect" },
  showmatch = true,

  -- 14 tabs and indenting
  -- REF: https://arisweedler.medium.com/tab-settings-in-vim-1ea0863c5990
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  softtabstop = 2,
  autoindent = true,
  smartindent = true,
  -- cindent = true, -- fix markdown code block indents, but may randomly indent sometimes
  -- cinoptions

  -- 15 folding (zopen/zclose, zReveal/zMinimise)
  -- TODO: use TS query to find all functions/methods - vifzc, repeat with classes, then zR
  -- BUG: sometimes opened folds close to default level when switching focus (if not ":e")
  foldenable = default_folds,
  foldlevel = 0, -- default levels folded
  foldlevelstart = 0, -- default for functional languages
  foldcolumn = "auto",
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  -- foldminlines = 1, -- min lines required for a fold (default)
  -- foldnestmax = 3, -- maximum nesting of folds

  -- 18 reading and writing files
  writebackup = true,
  autoread = true,

  -- 19 the swap file
  swapfile = false,
  -- updatetime = 1500,

  -- 20 command line editing
  wildmode = "full",
  wildmenu = true,
  wildoptions = "tagfile",

  -- 25 various
  -- signcolumn = "number", -- TODO: find a way put symbol next to line number
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

-- Filetype foldlevelstart override
if default_folds then
  local foldlevels = {
    java = 2,
    markdown = 1,
  }
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Larger fold level",
    pattern = vim.tbl_keys(foldlevels),
    callback = function(opts)
      local filetype = vim.api.nvim_buf_get_option(opts.buf, "filetype")
      vim.opt_local.foldlevel = foldlevels[filetype]
    end,
  })
end
