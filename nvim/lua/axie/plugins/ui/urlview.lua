local M = {}

M.cmd = "UrlView"

M.keys = {
  { "\\u", "<Cmd>UrlView<CR>", desc = "Buffer URLs" },
  { "\\U", "<Cmd>UrlView lazy<CR>", desc = "Plugin URLs" },
}

function M.config()
  require("urlview").setup({
    default_title = "Links",
    log_level_min = vim.log.levels.TRACE,
    jump = {
      prev = "[U",
      next = "]U",
    },
  })

  local search = require("urlview.search")
  local search_helpers = require("urlview.search.helpers")
  search.jira = search_helpers.generate_custom_search({
    capture = "AXIE%-%d+",
    format = "https://jira.axieax.com/browse/%s",
  })
end

return M
