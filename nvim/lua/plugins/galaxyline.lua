-- https://github.com/NTBBloodbath/galaxyline.nvim --

-- https://elianiva.my.id/post/neovim-lua-statusline
-- File indent size? mixed indent warning
-- TODO: venv
-- TODO: group linecol and percentage ()
-- TODO: decouple onedark colours

local ternary = require("utils").ternary
local diagnostics_icons = require("utils.config").diagnostics_icons
local fileformat_icons = require("utils.config").fileformat_icons

local M = {}

local filesize_enabled = true

function M.get_component(name)
  -- Colours
  -- ~/.local/share/nvim/site/pack/packer/opt/galaxyline.nvim/lua/galaxyline/themes/colors.lua
  local galaxyline_colours = require("galaxyline.themes.colors").default
  -- ~/.local/share/nvim/site/pack/packer/start/onedarkpro.nvim/lua/onedarkpro/colors/onedark.lua
  local onedark_colours = require("onedarkpro").get_colors("onedark")

  -- Helper functions
  local filesize = require("filesize")
  local filesize_options = {
    bits = true,
    spacer = "",
    round = 1,
    suffixes = {
      b = "",
      Kb = "k",
      Mb = "m",
      Gb = "g",
      Tb = "t",
      Pb = "p",
      Eb = "e",
      Zb = "z",
      Yb = "y",
    },
  }

  local components = {
    -- Incremental Scroll Bar
    ScrollBar = {
      provider = function()
        return require("galaxyline.providers.extensions").scrollbar_instance({
          "_",
          "▁",
          "▂",
          "▃",
          "▄",
          "▅",
          "▆",
          "▇",
          "█",
        })
      end,
      -- separator = " ",
      -- highlight = { galaxyline_colours.yellow, onedark_colours.orange },
      highlight = { onedark_colours.highlight, onedark_colours.orange },
    },

    -- Vim Mode Component
    VimMode = {
      provider = function()
        local modes = {
          -- Normal
          n = { "Normal", galaxyline_colours.violet },
          no = { "Operator Pending", galaxyline_colours.violet },
          -- Insert
          i = { "Insert", galaxyline_colours.yellow },
          -- Visual
          v = { "Visual", galaxyline_colours.magenta },
          V = { "Visual Line", galaxyline_colours.magenta },
          [""] = { "Visual Block", galaxyline_colours.magenta },
          -- Select
          s = { "Select", galaxyline_colours.blue },
          S = { "Select Line", galaxyline_colours.blue },
          [""] = { "Select Block", galaxyline_colours.blue },
          -- Replace
          R = { "Replace", galaxyline_colours.red },
          Rv = { "Virtual Replace", galaxyline_colours.red },
          -- Exec
          c = { "Command", galaxyline_colours.orange },
          cv = { "Vim Ex", galaxyline_colours.green },
          ce = { "Normal Ex", galaxyline_colours.green },
          r = { "Hit-Enter Prompt", galaxyline_colours.cyan },
          rm = { "More Prommpt", galaxyline_colours.cyan },
          ["r?"] = { "Confirm Query", galaxyline_colours.green },
          ["!"] = { "Shell", galaxyline_colours.orange },
          t = { "Terminal", galaxyline_colours.green },
        }

        -- local mode_abbrev = vim.api.nvim_get_mode().mode
        local mode_abbrev = vim.fn.mode()

        local mode = modes[mode_abbrev]
        local mode_text = ternary(mode ~= nil, mode[1], "Unknown: " .. mode_abbrev)
        local mode_colour = ternary(mode ~= nil, mode[2], galaxyline_colours.red)

        vim.api.nvim_command("hi GalaxyVimMode guifg=" .. mode_colour)
        return mode_text
      end,
      icon = "   ",
      separator = " ",
    },

    -- File Info Components
    FileNameIcon = {
      provider = function()
        return " "
      end,
      highlight = { "#d9a3af" },
    },
    FileIcon = {
      provider = "FileIcon",
      highlight = { onedark_colours.cyan },
    },
    FileName = {
      provider = "FileName",
      -- separator = " ",
      highlight = { "#debac3" },
    },
    FileFormat = {
      provider = function()
        return vim.bo.fileformat
      end,
      icon = function()
        return fileformat_icons[vim.bo.fileformat] .. " "
      end,
      separator = " ",
      highlight = { "#dbbade" },
    },
    WordCount = {
      provider = function()
        -- TODO: caching, human readable chars?
        local wc = vim.fn.wordcount()
        if wc.chars >= 1000000 then
          -- filesize_enabled = false
          -- return ""
        end
        return filesize(wc.words, filesize_options):gsub("b", "")
          .. ":"
          .. filesize(wc.chars, filesize_options):gsub("b", "")
      end,
      icon = " ",
      condition = function()
        return filesize_enabled
      end,
      separator = " ",
      highlight = { onedark_colours.purple },
    },
    LineColumn = {
      -- provider = "LineColumn",
      provider = function()
        local line = vim.fn.line(".")
        local line_pad = ternary(line < 100, "0", "")
        local col = vim.fn.col(".")
        local col_pad = ternary(col < 10, "0", "")
        return line_pad .. line .. ":" .. col_pad .. col .. " "
      end,
      icon = " ",
      separator = " ",
      -- highlight = { onedark_colours.orange },
      highlight = { onedark_colours.dark_purple },
    },

    -- Git Components
    GitBranch = {
      provider = "GitBranch",
      icon = " ",
      separator = " ",
      highlight = { onedark_colours.bg_blue },
    },
    DiffAdd = {
      provider = "DiffAdd",
      icon = " ",
      highlight = { onedark_colours.green },
    },
    DiffModified = {
      provider = "DiffModified",
      icon = " ",
      highlight = { onedark_colours.yellow },
    },
    DiffRemove = {
      provider = "DiffRemove",
      icon = " ",
      highlight = { onedark_colours.red },
    },

    -- LSP / Diagnostics Components
    LspClient = {
      provider = function()
        return require("galaxyline.providers.lsp").get_lsp_client("", { "null-ls" })
      end,
      highlight = { onedark_colours.cyan },
    },
    DiagnosticError = {
      provider = "DiagnosticError",
      icon = diagnostics_icons.Error .. " ",
      separator = " ",
      highlight = { onedark_colours.red },
    },
    DiagnosticWarn = {
      provider = "DiagnosticWarn",
      icon = diagnostics_icons.Warn .. " ",
      separator = " ",
      highlight = { onedark_colours.yellow },
    },
    DiagnosticHint = {
      provider = "DiagnosticHint",
      icon = diagnostics_icons.Hint .. " ",
      separator = " ",
      highlight = { onedark_colours.cyan },
    },
    DiagnosticInfo = {
      provider = "DiagnosticInfo",
      icon = diagnostics_icons.Info .. " ",
      separator = " ",
      highlight = { onedark_colours.blue },
    },

    -- Misc Components
    Divider = {
      provider = function()
        return "  + "
      end,
      separator = " ",
      highlight = { onedark_colours.bg_blue },
    },
  }

  return {
    [name] = components[name],
  }
end

function M.setup()
  local galaxyline = require("galaxyline")

  -- Define the structure of the statusline
  local get_component = require("plugins.galaxyline").get_component
  galaxyline.section = {
    -- Regular statusline
    left = {
      get_component("ScrollBar"),
      get_component("VimMode"),
      get_component("FileNameIcon"),
      get_component("FileName"),
      get_component("GitBranch"),
      get_component("DiffAdd"),
      get_component("DiffModified"),
      get_component("DiffRemove"),
    },

    mid = {
      get_component("DiagnosticError"),
      get_component("DiagnosticWarn"),
      get_component("DiagnosticHint"),
      get_component("DiagnosticInfo"),
    },

    right = {
      get_component("FileIcon"),
      get_component("LspClient"),
      get_component("FileFormat"),
      get_component("WordCount"),
      get_component("LineColumn"),
      get_component("ScrollBar"),
    },

    -- Short statusline
    short_line_left = {
      get_component("ScrollBar"),
    },

    short_line_mid = {
      get_component("VimMode"),
      get_component("Divider"),
      get_component("FileName"),
      get_component("FileNameIcon"),
    },

    short_line_right = {
      get_component("ScrollBar"),
    },
  }

  -- Define filetypes which should use the short status line
  -- NOTE: floating windows use the short status line by default
  galaxyline.short_line_list = {
    "qf",
    "NvimTree",
    "aerial",
    "Mundo",
    "Trouble",
    "toggleterm",
    "alpha",
    "minimap",
  }

  -- Transparent gaps between sections
  vim.cmd("hi GalaxyLineFillSection guibg=NONE")
end

return M
