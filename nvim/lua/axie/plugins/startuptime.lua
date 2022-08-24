local M = {}

function M.setup()
  -- update startup time
  local startuptime_group = vim.api.nvim_create_augroup("StartupTimeUpdate", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = startuptime_group,
    pattern = "StartupTimeSaved",
    callback = function()
      local startuptime = vim.g.startuptime.startup.mean
      -- require("axie.utils").notify(tostring(startuptime), "info", { title = "Startup Time", render = "default" })
      vim.notify(string.format(" Startup Time: %.3f seconds", startuptime), vim.log.levels.WARN)
      vim.defer_fn(function()
        vim.api.nvim_echo({ { "" } }, false, {})
      end, 3000)
      require("axie.plugins.startscreen").update_startuptime(startuptime)
    end,
  })
end

function M.calculate_startup_time()
  pcall(vim.cmd, "StartupTime --save startuptime --hidden")
end

return M
