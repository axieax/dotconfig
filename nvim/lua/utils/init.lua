-- Helper functions
local M = {}

-- Applies options to a meta-accessor
-- @param meta_accessor table: vim meta-accessor such as vim.opt
-- @param options table: key-value table for settings to be applied
function M.vim_apply(meta_accessor, options)
  for k, v in pairs(options) do
    meta_accessor[k] = v
  end
end

-- Keymapping wrapper
local default_options = {
  noremap = true,
  silent = true,
  expr = false,
  script = false,
}

-- Sets nvim keybinds
-- bind = {
-- 	mode,
-- 	before,
-- 	after,
-- 	noremap,
-- 	silent,
-- 	expr,
-- 	script,
-- }

function M.map(bind)
  -- Set defaults
  local mode = bind[1]
  local before = bind[2]
  local after = bind[3]
  local noremap = (bind.noremap == nil and default_options.noremap) or bind.noremap
  local silent = (bind.silent == nil and default_options.silent) or bind.silent
  local expr = (bind.expr == nil and default_options.expr) or bind.expr
  local script = (bind.script == nil and default_options.script) or bind.script

  -- Pass settings to keymap API call
  vim.api.nvim_set_keymap(mode, before, after, {
    noremap = noremap,
    silent = silent,
    expr = expr,
    script = script,
  })
end

function M.display(...)
  print(vim.inspect(...))
end

return M
