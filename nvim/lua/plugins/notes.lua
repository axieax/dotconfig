-- https://github.com/folke/todo-comments.nvim --

return function()
  require("todo-comments").setup({
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "HELP" },
      },
      WARN = {
        icon = " ",
        color = "error",
        alt = { "WARNING", "XXX", "BAD", "ERROR" },
      },
      TODO = {
        icon = " ",
        color = "hint",
      },
      HACK = {
        icon = " ",
        color = "warning",
      },
      PERF = {
        icon = " ",
        color = "warning",
        alt = { "PERFORMANCE", "OPTIM", "OPTIMIZE", "OPTIMISE", "EFFICIENCY", "TEST" },
      },
      NOTE = {
        icon = " ",
        color = "info",
        alt = { "INFO" },
      },
    },
    highlight = {
      before = "empty",
      keyword = "bg",
      after = "fg",
    },
  })
end
