-- TODO: fix style: _G.global_name OR require this file every time (later preferred)
require("utils.config")

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
	expr = false,
}

-- Sets nvim keybinds
-- bind = {
-- 	mode,
-- 	before,
-- 	after,
-- 	noremap,
-- 	silent,
-- 	expr,
-- }

function map( bind )
	-- Set defaults
	local mode = bind[1]
	local before = bind[2]
	local after = bind[3]
	local noremap = bind.noremap
	local silent = bind.silent
	local expr = bind.expr

	if noremap == nil then
		noremap = default_options.noremap
	end
	if silent == nil then
		silent = default_options.silent
	end
	if expr == nil then
		expr = default_options.expr
	end
  -- Pass settings to keymap API call
	vim.api.nvim_set_keymap(mode, before, after, {
		noremap = noremap,
		silent = silent,
		expr = expr,
	})
end

