local M = {}

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
