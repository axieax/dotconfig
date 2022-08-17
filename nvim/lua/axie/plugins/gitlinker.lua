local M = {}

function M.config()
  local gitlinker = require("gitlinker")
  local require_args = require("axie.utils").require_args
  gitlinker.setup({
    mappings = "<space>gy",
  })
  -- Open line link in browser (visual mode map)
  vim.keymap.set(
    "v",
    "<space>gw",
    require_args(gitlinker.get_buf_range_url, "v", { action_callback = require("gitlinker.actions").open_in_browser }),
    { desc = "open line link in browser" }
  )
end

return M
