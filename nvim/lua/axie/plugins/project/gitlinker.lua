local M = {}

M.keys = {
  { "<Space>gy", mode = { "n", "v" } },
  {
    "<Space>gw",
    function()
      require("gitlinker").get_buf_range_url("n", {
        action_callback = require("gitlinker.actions").open_in_browser,
      })
    end,
    mode = "n",
    desc = "open line link in browser",
  },
  {
    "<Space>gw",
    function()
      require("gitlinker").get_buf_range_url("v", {
        action_callback = require("gitlinker.actions").open_in_browser,
      })
    end,
    mode = "v",
    desc = "open line link in browser",
  },
}

function M.config()
  require("gitlinker").setup({ mappings = "<Space>gy" })
end

return M
