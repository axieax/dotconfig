local M = {}

M.cmd = {
  "DiffviewOpen",
  "DiffviewFileHistory",
  "DiffviewClose",
  "DiffviewFocusFiles",
  "DiffviewToggleFiles",
  "DiffviewRefresh",
  "DiffviewLog",
}

M.keys = {
  { "<Space>gdd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview + merge conflicts" },
  { "<Space>gdf", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git diff (file)" },
  { "<Space>gdr", "<Cmd>DiffviewFileHistory<CR>", desc = "Git diff (repo)" },
  { "<Space>gdm", "<Cmd>DiffviewOpen main<CR>", desc = "Git diff (main)" },
  { "<Space>gdM", "<Cmd>DiffviewOpen master<CR>", desc = "Git diff (master)" },
  { "<Space>gdq", "<Cmd>DiffviewClose<CR>", desc = "Git diff close" },
}

M.opts = {
  view = {
    default = { winbar_info = true },
    merge_tool = { winbar_info = true, layout = "diff3_mixed", disable_diagnostics = false },
    file_history = { winbar_info = true },
  },
}

return M
