local M = {}

function M.config()
  require("nvim-autopairs").setup({
    -- insert mode "alt-e"
    -- NOTE: vim surround visual selection: S_ as well
    fast_wrap = {},
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
