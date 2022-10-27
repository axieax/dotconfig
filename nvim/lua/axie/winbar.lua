local M = {}

local utils = require("axie.utils")
local ignored_filetypes = {
  "",
  "alpha",
  "neo-tree", -- NOTE: managed by neo-tree
  "toggleterm",
  "packer",
  "lspinfo",
  "null-ls-info",
  "glowpreview",
  "help",
  "man",
  "prompt",
  "mason",
  "aerial",
  "checkhealth",
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

-- REFERENCE: nvim-navic
local kind_icons = {
  File = " ",
  Module = " ",
  Namespace = " ",
  Package = " ",
  Class = " ",
  Method = " ",
  Property = " ",
  Field = " ",
  Constructor = " ",
  Enum = "練",
  Interface = "練",
  Function = " ",
  Lambda = "λ",
  Variable = " ",
  Constant = " ",
  String = " ",
  Number = " ",
  Boolean = "◩ ",
  Array = " ",
  Object = " ",
  Key = " ",
  Null = "ﳠ ",
  EnumMember = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Macro = " ",
}

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
        return highlight(kind_icons.Lambda, "NavicIconsFunction")
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

      return highlight(kind_icons[symbol.kind], "NavicIcons" .. symbol.kind) .. text
    end, symbols),
    "  "
  )

  return utils.ternary(context ~= "", highlight(":: ", "NavicSeparator") .. context, "")
end

local focused_win = vim.api.nvim_get_current_win()

function M.eval()
  local is_nc = focused_win ~= vim.api.nvim_get_current_win()
  local file_hl = "NavicIconsFile" .. utils.ternary(is_nc, "NC", "")
  local modified = vim.api.nvim_buf_get_option(0, "modified")

  local _, value = pcall(function()
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
  return value
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
