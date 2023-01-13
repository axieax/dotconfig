local M = {}

M.cmd = {
  "RegexplainerShow",
  "RegexplainerHide",
  "RegexplainerToggle",
  "RegexplainerYank",
  "RegexplainerShowSplit",
  "RegexplainerShowPopup",
  "RegexplainerDebug",
}

M.keys = { "gR" }

M.opts = {
  auto = false,
  display = "popup",
  popup = {
    border = {
      padding = { 0, 0 },
      style = "rounded",
    },
    win_options = { winblend = 20 },
  },
  mappings = { toggle = "gR" },
}

return M
