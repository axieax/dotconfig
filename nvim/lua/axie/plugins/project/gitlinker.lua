local M = {}

M.keys = {
  { "<Space>gy", mode = { "n", "v" }, desc = "Copy Git line reference URL to clipboard" },
  {
    "<Space>gY",
    function()
      require("gitlinker").get_repo_url()
    end,
    mode = "n",
    desc = "Copy Git repo URL to clipboard",
  },
  {
    "<Space>gw",
    function()
      require("gitlinker").get_buf_range_url("n", {
        action_callback = require("gitlinker.actions").open_in_browser,
      })
    end,
    mode = "n",
    desc = "Open Git line reference URL in browser",
  },
  {
    "<Space>gw",
    function()
      require("gitlinker").get_buf_range_url("v", {
        action_callback = require("gitlinker.actions").open_in_browser,
      })
    end,
    mode = "v",
    desc = "Open Git line reference URL in browser",
  },
  {
    "<Space>gW",
    function()
      require("gitlinker").get_repo_url("n", {
        action_callback = require("gitlinker.actions").open_in_browser,
      })
    end,
    mode = "n",
    desc = "Open Git repo URL in browser",
  },
}

M.opts = { mappings = "<Space>gy" }

return M
