local M = {}

M.dev_mode = false
M.nvchad_theme = true
M.copilot_enabled = true
M.colorscheme = "catppuccin"
M.default_folds = false

-- Icons
M.diagnostics_icons = {
  Error = "",
  Warn = "",
  Hint = "󰍉",
  -- Hint = "",
  Info = "",
  VirtualText = "",
}

M.fileformat_icons = {
  unix = "",
  mac = "",
  dos = "",
}

M.symbol_icons = {
  File = "󰈙",
  Folder = "󰉋",
  Module = "",
  Package = "",
  Namespace = "", -- 󰌗
  Struct = "",
  Class = "󰠱", --  
  Function = "󰊕", -- 
  Lambda = "λ",
  Method = "󰊕",
  Constructor = "",
  Interface = "",
  Enum = "",
  EnumMember = "",
  Property = "",
  Field = "󰜢", -- 󰇽
  Object = "󰅩",
  Key = "󰌋",
  Value = "󰎠", -- 󰕘
  Array = "",
  Variable = "󰀫",
  Constant = "󰏿", -- 
  String = "",
  Number = "󰎠",
  Boolean = "󰨙", -- 
  Unit = "",
  Null = "󰟢",
  Operator = "󰆕",
  TypeParameter = "󰉿", -- 󰅲
  Text = "",
  Event = "",
  Macro = "",
  Reference = "", -- 
  Snippet = "", -- 
  Color = "",
  Keyword = "󰌋",
}

return M
