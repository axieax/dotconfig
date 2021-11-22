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
      QUESTION = {
        icon = " ",
        color = "error",
        alt = { "IDK" },
      },
      BOOKMARK = {
        icon = " ",
        color = "warning",
        alt = { "CHECK", "READ", "LOOK", "REVIEW", "HERE" },
      },
    },
    highlight = {
      before = "empty",
      keyword = "bg",
      after = "fg",
    },
    search = {
      -- NOTE: doesn't seem to work
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      -- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  })
end
