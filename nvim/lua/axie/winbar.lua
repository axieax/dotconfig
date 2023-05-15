local M = {}

local utils = require("axie.utils")
local symbol_icons = require("axie.utils.config").symbol_icons

local ignored_filetypes = {
  "",
  "alpha",
  "neo-tree", -- NOTE: managed by neo-tree
  "toggleterm",
  "lspinfo",
  "null-ls-info",
  "glowpreview",
  "help",
  "man",
  "prompt",
  "mason",
  "aerial",
  "checkhealth",
  "qf",
  "netrw",
}

local function highlight(content, hl_group)
  return string.format("%%#%s#%s%%*", hl_group, content)
end

local function clickable(content, fn_name)
  fn_name = "v:lua.require'axie.winbar'." .. fn_name
  return string.format("%%0@%s@%s%%T", fn_name, content)
end

function M.file_icon()
  local filetype = vim.fn.expand("%:p:e")
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    local icon = devicons.get_icon("", filetype)
    if icon then
      return icon
    end
  end
  return ""
end

function M.file_name()
  return vim.fn.expand("%:p:t")
end

local show_context = true

function M.toggle_context()
  show_context = not show_context
end

function M.context()
  if not show_context then
    return ""
  end

  local ok, aerial = pcall(require, "aerial")
  if not ok then
    return ""
  end

  local symbols = aerial.get_location(false)
  local context = table.concat(
    vim.tbl_map(function(symbol)
      -- anonymous function
      if symbol.kind == "Function" and symbol.name == "<Anonymous>" then
        return highlight(symbol_icons.Lambda, "NavicIconsFunction")
      end

      -- highlight function parameters
      local text = highlight(symbol.name, "NavicText")
      if vim.tbl_contains({ "Function", "Method", "Constructor" }, symbol.kind) then
        local name, param_list = string.match(symbol.name, "(.+)%((.*)%)")
        if name and param_list then
          local params = vim.split(param_list, ", ")
          local comma = highlight(", ", "NavicText")
          text = highlight(name .. "(", "NavicText")
            .. table.concat(
              vim.tbl_map(function(param)
                return highlight(param, "NavicIconsProperty")
              end, params),
              comma
            )
            .. highlight(")", "NavicText")
        end
      end

      return highlight(symbol.icon .. " ", "NavicIcons" .. symbol.kind) .. text
    end, symbols),
    "  "
  )

  return context ~= "" and highlight(":: ", "NavicSeparator") .. context or ""
end

local focused_win = vim.api.nvim_get_current_win()

function M.eval()
  local is_nc = focused_win ~= vim.api.nvim_get_current_win()
  local file_hl = "NavicIconsFile" .. (is_nc and "NC" or "")
  local modified = vim.api.nvim_buf_get_option(0, "modified")

  local ok, value = pcall(function()
    local components = {
      highlight(modified and "*" or "", "WinBarModified"),
      highlight(M.file_icon(), file_hl),
      highlight(clickable(M.file_name(), "toggle_context"), file_hl),
    }
    if not is_nc then
      table.insert(components, highlight(M.context(), "WinBarContext"))
    end

    return table.concat(components, " ")
  end)
  return ok and value or highlight(value, "ErrorMsg")
end

function M.show_winbar()
  local win = vim.api.nvim_get_current_win()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if not vim.tbl_contains(ignored_filetypes, filetype) then
    vim.api.nvim_win_set_option(win, "winbar", "%{%v:lua.require'axie.winbar'.eval()%}")
  end
  focused_win = win
end

function M.activate()
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWinLeave" }, {
    group = vim.api.nvim_create_augroup("WinBarGroup", {}),
    callback = vim.schedule_wrap(M.show_winbar),
  })
end

return M
