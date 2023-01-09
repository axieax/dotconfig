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

function M.config()
  require("regexplainer").setup({
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
  })
end

return M
