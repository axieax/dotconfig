local M = {}

-- insert mode "alt-e"
-- NOTE: vim surround visual selection: S_ as well
M.opts = { fast_wrap = {} }

function M.config(_, opts)
  require("nvim-autopairs").setup(opts)

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
