-- https://github.com/catppuccin/nvim --

return function()
  local catppuccin = require("catppuccin")
  catppuccin.setup({
    transparent_background = true,
    integrations = {
      lsp_trouble = true,
      cmp = true,
      lsp_saga = true,
      gitgutter = false,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = true,
        show_root = false,
      },
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      dashboard = true,
      neogit = true,
      vim_sneak = true,
      fern = true,
      barbar = true,
      bufferline = true,
      markdown = true,
      lightspeed = true,
      ts_rainbow = true,
      hop = true,
      notify = true,
      telekasten = true,
    },
  })

  -- highlight group overrides
  local cp = require("catppuccin.api.colors").get_colors()
  catppuccin.remap({
    NormalFloat = { bg = cp.black2 }, -- NOTE: catppuccin needs a bg colour
    ColorColumn = { link = "CursorLine" },
    CursorLineNr = { fg = cp.magenta },
    -- NvimTreeNormal = { bg = cp.none },
    WhichKeyFloat = { bg = cp.black2 },
    SpellBad = { fg = cp.red },
    SpellCap = { fg = cp.red },
    SpellLocal = { fg = cp.red },
    SpellRare = { fg = cp.red },
    -- SpellBad = { fg = cp.maroon },
    -- SpellCap = { fg = cp.peach },
    -- SpellLocal = { fg = cp.lavender },
    -- SpellRare = { fg = cp.teal },
  })
  vim.cmd("au ColorScheme catppuccin hi NvimTreeNormal guibg=NONE")

  vim.cmd("colorscheme catppuccin")
end
