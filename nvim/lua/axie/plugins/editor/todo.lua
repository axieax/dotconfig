local M = {}

M.keys = {
  {
    "[c",
    function()
      require("todo-comments").jump_prev()
    end,
    desc = "Previous todo comment",
  },
  {
    "]c",
    function()
      require("todo-comments").jump_next()
    end,
    desc = "Next todo comment",
  },
  {
    "<Space>fq",
    "<Cmd>TodoQuickFix<CR>",
    desc = "Project todo comments",
  },
}

M.opts = {
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "BAD", "FIXIT", "ISSUE", "HELP", "PRIOR", "PRIORITY", "PROBLEM" },
    },
    WARN = {
      icon = " ",
      color = "error",
      alt = { "WARNING", "XXX", "BAD", "ERROR" },
    },
    TODO = {
      icon = " ",
      color = "hint",
      alt = { "NEW", "ACTION", "ACTIONABLE", "OPTIONAL", "MAYBE" },
    },
    HACK = {
      icon = " ",
      color = "warning",
      alt = { "TEMP", "TEMPORARY", "CHANGE", "UPDATE", "CONFIRM", "CHECK" },
    },
    PERF = {
      icon = " ",
      color = "warning",
      alt = { "PERFORMANCE", "OPTIM", "OPTIMIZE", "OPTIMISE", "EFFICIENCY", "TEST" },
    },
    NOTE = {
      icon = " ",
      color = "info",
      alt = {
        "INFO",
        "INSTALL",
        "SETUP",
        "GUIDE",
        "ASSUMPTION",
        "ASSUME",
        "ASSUMES",
        "SOURCE",
        "REFERENCE",
        "REF",
        "REFACTOR",
        "DEP",
        "DEPENDENCY",
        "DEPENDENCIES",
      },
    },
    QUESTION = {
      icon = " ",
      color = "error",
      alt = { "IDK", "THOUGHT", "POSSIBLE" },
    },
    BOOKMARK = {
      icon = " ",
      color = "warning",
      alt = {
        "READ",
        "WATCH",
        "LOOK",
        "SEE",
        "REVIEW",
        "HERE",
        "IMPORTANT",
        "BIG",
        "EXTENSION",
        "LINK",
        "USEFUL",
        "HELPFUL",
      },
    },
    IDEA = {
      icon = " ",
      color = "hint",
      alt = { "SUGGEST", "SUGGESTION", "TRY", "CONSIDER", "ALT", "ALTERNATIVE", "INSPO", "INSPIRATION", "RANDOM" },
    },
    FORK = {
      icon = " ",
      color = "hint",
    },
  },
  highlight = {
    pattern = [[.*<(KEYWORDS)\s*]],
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
}

return M
