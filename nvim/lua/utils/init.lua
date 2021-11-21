-- Helper functions
local M = {}

-- Applies options to a meta-accessor
-- @param meta_accessor (table) vim meta-accessor, such as vim.opt
-- @param options (table) key-value table for settings to be applied
function M.vim_apply(meta_accessor, options)
  for k, v in pairs(options) do
    meta_accessor[k] = v
  end
end

-- Default options for keymap settings
local default_options = {
  noremap = true,
  silent = true,
  expr = false,
  script = false,
}

-- Registers a keymapping
-- @param bind (table) consisting of {
--    mode (positional, string)
--    before (positional, string)
--    after (positional, string)
--    noremap (optional keyword, boolean)
--    silent (optional keyword, boolean)
--    expr (optional keyword, boolean)
--    script (optional keyword, boolean)
-- }
function M.map(bind)
  -- Get options
  local unpack = M.fallback_value(table.unpack, unpack)
  local mode, before, after = unpack(bind, 1, 3)
  local noremap = M.fallback_value(bind.noremap, default_options.noremap)
  local silent = M.fallback_value(bind.silent, default_options.silent)
  local expr = M.fallback_value(bind.expr, default_options.expr)
  local script = M.fallback_value(bind.script, default_options.script)

  -- Register keymap with specified options
  vim.api.nvim_set_keymap(mode, before, after, {
    noremap = noremap,
    silent = silent,
    expr = expr,
    script = script,
  })
end

-- Returns value or fallback (nullish coalescing)
-- @param value to be checked
-- @param fallback value which may be used
-- @param fallback_comparison used to compare with value, leave empty for default nil
function M.fallback_value(value, fallback, fallback_comparison)
  return (value == fallback_comparison and fallback) or value
end

-- Helper function for mimicking the ternary operator
-- @param condition
-- @param first
-- @param second
function M.ternary(condition, first, second)
  return (condition and first) or second
end

-- Debug printing
function M.display(...)
  print(vim.inspect(...))
end

-- Send a notification
function M.notify(...)
  local ok, notifier = pcall(require, "notify")
  if not ok then
    notifier = vim
  end
  notifier.notify(...)
end

return M
