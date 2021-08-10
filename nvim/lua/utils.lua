-- Applies options to a meta-accessor
-- @param meta_accessor table: vim meta-accessor such as vim.opt
-- @param options table: key-value table for settings to be applied
function vim_apply(meta_accessor, options)
  for k,v in pairs(options) do
    meta_accessor[k] = v
  end
end

-- Keymapping wrapper
local default_options = {
  noremap = true,
  silent = true,
}

function map(mode, before, after, options)
  if options == nil then
    options = default_options
  end
  vim.api.nvim_set_keymap(mode, before, after, options)
end

