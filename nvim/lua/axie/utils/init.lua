-- Helper functions
-- TODO: apply highlight group
local M = {}

-- Applies options to a meta-accessor
-- @param meta_accessor (table) vim meta-accessor, such as vim.opt
-- @param options (table) key-value table for settings to be applied
function M.vim_apply(meta_accessor, options)
  for k, v in pairs(options) do
    meta_accessor[k] = v
  end
end

--- Sets a given keymap conditionally based on a given filetype
-- @param filetype (string) filetype to register keymap
---@vararg any `vim.keymap.set` arguments (mode, lhs, rhs, opts) with optional opts
function M.filetype_map(ft, mode, lhs, rhs, opts)
  -- set buffer option by default
  opts = vim.tbl_extend("keep", opts or {}, { buffer = true })
  vim.api.nvim_create_autocmd("FileType", {
    desc = string.format("%s map for %s", ft, lhs),
    pattern = ft,
    callback = function()
      vim.keymap.set(mode, lhs, rhs, opts)
    end,
  })
end

--- Overrides the filetype for files matching the given pattern
---@param pattern (string|table) pattern to match
---@param ft (string) filetype to set
function M.override_filetype(pattern, ft)
  if type(pattern) == "string" then
    pattern = { pattern }
  end

  local config = {}
  for _, p in ipairs(pattern) do
    config[p] = ft
  end

  vim.filetype.add({ pattern = config })
end

--- Determines whether to accept the current value or use a fallback value (nullish coalescing)
---@param value any @value to check
---@param fallback_value any @fallback value to use
---@param fallback_comparison any @fallback comparison, defaults to nil
---@return any @value, or @fallback if @value is @fallback_comparison
function M.fallback(value, fallback_value, fallback_comparison)
  return (value == fallback_comparison and fallback_value) or value
end

--- Mimics the ternary operator
---@param condition boolean @condition to check
---@param if_true any @value to return if @condition is true
---@param if_false any @value to return if @condition is false
---@return any @condition ? if_true : if_false
function M.ternary(condition, if_true, if_false)
  return (condition and if_true) or if_false
end

-- Send a notification
-- NOTE: notify plugin accepts table as multi-line string, vim.notify has opts
function M.notify(...)
  local ok, notifier = pcall(require, "notify")
  if not ok then
    notifier = vim
  end
  notifier.notify(...)
end

-- Display path of current buffer
function M.display_path()
  M.notify(vim.fn.fnamemodify(vim.fn.expand("%"), ":p"), "info", {
    title = "path",
    render = "default",
  })
end

-- Display path of current working directory
function M.display_cwd()
  M.notify(vim.loop.cwd(), "info", {
    title = "cwd",
    render = "default",
  })
end

-- vim.tbl_flatten limited to only once (top-level)
function M.list_flatten_once(list)
  local result = {}
  for _, t in ipairs(list) do
    for _, v in ipairs(t) do
      table.insert(result, v)
    end
  end
  return result
end

function M.get_os()
  return vim.loop.os_uname().sysname:lower():gsub("darwin", "mac")
end

--- Reloads a module's require cache
---@param module_name (string) module to reload
---@vararg any additional arguments to pass to plenary reload module
function M.reload_module(module_name, ...)
  local ok, plenary = pcall(require, "plenary.reload")
  if ok then
    plenary.reload_module(module_name, ...)
  else
    M.notify("Could not reload module: " .. module_name)
  end
end

--- Returns a function which calls f with the given arguments
---@param f (function|string) function to be called
---@vararg any arguments to be passed to f
---@return function
function M.require_args(f, ...)
  local args = { ... }
  if type(f) == "string" then
    f = require(f)
  end
  return function()
    return f(unpack(args))
  end
end

--- Restores position after calling @func
---@param func function @to be wrapped
---@return function
function M.restore_position_wrap(func)
  return function(...)
    local pos = vim.api.nvim_win_get_cursor(0)
    func(...)
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local diagnostics_active = true
function M.toggle_diagnostics()
  if diagnostics_active then
    vim.diagnostic.hide()
  else
    vim.diagnostic.show()
  end
  diagnostics_active = not diagnostics_active
end

return M
