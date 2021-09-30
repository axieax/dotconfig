-- https://github.com/glepnir/galaxyline.nvim --
-- https://elianiva.my.id/post/neovim-lua-statusline
-- File indent size? mixed indent warning
-- TODO: venv
-- TODO: group linecol and percentage ()

-- BUG: highlight https://github.com/glepnir/galaxyline.nvim/issues/215

return function()
  -- Colours
  local colours = require("galaxyline.theme").default
  local onedark_colours = require("onedark.colors")

  -- Structures
  local section = require("galaxyline").section
  local lsp_diagnostics_icons = require("utils.config").lsp_diagnostics_icons

  -- Custom scroll bar
  local scrollbar_chars = { "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
  local custom_scroll_bar = {
    ScrollBar = {
      provider = function()
        return require("galaxyline.provider_extensions").scrollbar_instance(scrollbar_chars)
      end,
      -- separator = " ",
      highlight = { onedark_colours.orange, colours.yellow },
      -- highlight = { colours.red },
    },
  }

  -- LEFT --
  section.left = {
    custom_scroll_bar,
    {
      ViMode = {
        provider = function()
          local modes = {
            -- Normal
            n = { "Normal", colours.violet },
            no = { "Operator Pending", colours.violet },
            -- Insert
            i = { "Insert", colours.yellow },
            -- Visual
            v = { "Visual", colours.magenta },
            V = { "Visual Line", colours.magenta },
            [""] = { "Visual Block", colours.magenta },
            -- Select
            s = { "Select", colours.blue },
            S = { "Select Line", colours.blue },
            [""] = { "Select Block", colours.blue },
            -- Replace
            R = { "Replace", colours.red },
            Rv = { "Virtual Replace", colours.red },
            -- Exec
            c = { "Command", colours.orange },
            cv = { "Vim Ex", colours.green },
            ce = { "Normal Ex", colours.green },
            r = { "Hit-Enter Prompt", colours.cyan },
            rm = { "More Prommpt", colours.cyan },
            ["r?"] = { "Confirm Query", colours.green },
            ["!"] = { "Shell", colours.orange },
            t = { "Terminal", colours.green },
          }
          local mode_abbrev = vim.fn.mode()
          -- local mode_abbrev = vim.api.nvim_get_mode().mode
          local mode_text = "Unknown: " .. mode_abbrev
          local mode_colour = colours.red

          local mode = modes[mode_abbrev]
          if mode ~= nil then
            mode_text = mode[1]
            mode_colour = mode[2]
          end

          vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_colour)
          return mode_text
        end,
        icon = "   ",
        -- highlight = { colours.green, colours.purple },
        separator = " ",
        -- separator_highlight = { colours.purple, colours.darkblue },
      },
    },
    {
      GitBranch = {
        provider = "GitBranch",
        icon = " ",
        separator = " ",
        highlight = { onedark_colours.bg_blue },
      },
    },
    {
      DiffAdd = {
        provider = "DiffAdd",
        icon = " ",
        highlight = { onedark_colours.green },
      },
    },
    {
      DiffModified = {
        provider = "DiffModified",
        icon = " ",
        highlight = { onedark_colours.yellow },
      },
    },
    {
      DiffRemove = {
        provider = "DiffRemove",
        icon = " ",
        highlight = { onedark_colours.red },
      },
    },
  }

  -- MID --
  section.mid = {
    {
      DiagnosticError = {
        provider = "DiagnosticError",
        icon = lsp_diagnostics_icons.Error .. " ",
        separator = " ",
        highlight = { onedark_colours.red },
      },
    },
    {
      DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = lsp_diagnostics_icons.Warning .. " ",
        separator = " ",
        highlight = { onedark_colours.yellow },
      },
    },
    {
      DiagnosticHint = {
        provider = "DiagnosticHint",
        icon = lsp_diagnostics_icons.Hint .. " ",
        separator = " ",
        highlight = { onedark_colours.cyan },
      },
    },
    {
      DiagnosticInfo = {
        provider = "DiagnosticInfo",
        icon = lsp_diagnostics_icons.Information .. " ",
        separator = " ",
        highlight = { onedark_colours.blue },
      },
    },
  }

  -- RIGHT --
  section.right = {
    {
      FileIcon = {
        provider = "FileIcon",
        highlight = { onedark_colours.purple },
      },
    },
    {
      LspClient = {
        provider = "GetLspClient",
        highlight = { onedark_colours.purple },
      },
    },
    {
      LineColumn = {
        provider = "LineColumn",
        icon = " ",
        separator = " ",
        -- highlight = { onedark_colours.orange },
        highlight = { onedark_colours.dark_purple },
      },
    },
    custom_scroll_bar,
  }

  -- short_line_list section
end
