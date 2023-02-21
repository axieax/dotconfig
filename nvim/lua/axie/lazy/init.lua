local M = {}

local utils = require("axie.utils")

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)
end

function M.report_startuptime()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    group = vim.api.nvim_create_augroup("Lazy Startuptime", {}),
    callback = function()
      local stats = require("lazy").stats()
      vim.notify(string.format(" Startup Time: %.3f ms", stats.startuptime), vim.log.levels.WARN)
      vim.defer_fn(function()
        vim.api.nvim_echo({ { "" } }, false, {})
      end, 3000)
      require("axie.plugins.ui.alpha").update_startuptime(stats.loaded, stats.startuptime)
    end,
  })
end

function M.init()
  vim.keymap.set("n", "<Space>s", "<Cmd>Lazy<CR>")
end

function M.setup()
  M.bootstrap()
  M.init()
  M.report_startuptime()

  local colorscheme = require("axie.utils.config").colorscheme
  require("lazy").setup("axie.plugins", {
    defaults = { lazy = true },
    lockfile = vim.fn.expand("~/dotconfig/nvim/lua/axie/lazy/lazy-lock.json"),
    dev = { path = vim.fn.expand("~/dev/nvim-plugins"), fallback = true },
    install = {
      missing = true,
      colorscheme = { colorscheme },
    },
    checker = { enabled = true, notify = false },
  })
end

local resolve_keys = { "config", "init", "keys", "cmd", "opts" }

function M.transform_spec(specs, category)
  return vim.tbl_map(function(spec)
    -- Make all tables
    if type(spec) == "string" then
      spec = { spec }
    end
    local plugin_name = spec[1]

    -- Resolve keys automatically
    local mod_name = spec.settings
    if type(mod_name) == "string" then
      if not string.match(mod_name, "%.") then
        mod_name = string.format("plugins.%s.%s", category, mod_name)
      end
      mod_name = "axie." .. mod_name

      local ok, mod = pcall(require, mod_name)
      if not ok then
        utils.notify(string.format("%s: failed to load module %s", plugin_name, mod_name), vim.log.levels.ERROR)
        vim.notify(string.format("-- ERROR LOADING: %s --\n%s", plugin_name, vim.inspect(mod)), vim.log.levels.ERROR)
      else
        for _, resolve_key in ipairs(resolve_keys) do
          if mod[resolve_key] then
            spec[resolve_key] = mod[resolve_key]
          end
        end
      end
      spec.settings = nil
    end

    -- Recursively transform dependencies
    if type(spec.dependencies) == "table" then
      spec.dependencies = M.transform_spec(spec.dependencies, category)
    end

    return spec
  end, specs)
end

return M
