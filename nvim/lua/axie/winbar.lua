local M = {}

local utils = require("axie.utils")

local function decorate(hl_group, content)
  return string.format("%%#%s#%s%%*", hl_group, content)
end

function M.file_icon()
  local filetype = vim.fn.expand("%:p:e")
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local icon = devicons.get_icon(nil, filetype)
    if icon then
      return icon
    end
  end
  return ""
end

function M.file_name()
  return vim.fn.expand("%:p:t")
end

-- NOTE: doesn't include struct symbols
local function aerial_context()
  local ok, aerial = pcall(require, "aerial")
  if not ok then
    return ""
  end

  local symbols = aerial.get_location(true)
  return vim.fn.join(
    vim.tbl_map(function(symbol)
      return decorate("NavicIcons" .. symbol.kind, symbol.icon) .. " " .. decorate("NavicText", symbol.name)
    end, symbols),
    " > "
  )
end

function M.context()
  local context = require("nvim-navic").get_location()
  if context == "" then
    -- NOTE: navic slow startup for some LSPs -> use aerial instead
    context = aerial_context()
  end
  return utils.ternary(context ~= "", decorate("NavicSeparator", ":: ") .. context, "")
end

function M.eval()
  local _, value = pcall(function()
    local components = {
      { "NavicIconsFile", M.file_icon() },
      { "NavicIconsFile", M.file_name() },
      -- TODO: hide on NC?
      { "WinBarContext", M.context() },
    }

    return vim.fn.join(
      vim.tbl_map(function(component)
        return decorate(unpack(component))
      end, components),
      " "
    )
  end)
  return value
end

function M.activate()
  vim.o.winbar = "%{%v:lua.require'axie.winbar'.eval()%}"
  vim.schedule(function()
    local float_bg = vim.api.nvim_get_hl_by_name("NormalFloat", true).background
    vim.api.nvim_set_hl(0, "WinBar", { bg = float_bg })
    -- TODO: different fg for NC?
    vim.api.nvim_set_hl(0, "WinBarNC", {})
  end)
end

return M
