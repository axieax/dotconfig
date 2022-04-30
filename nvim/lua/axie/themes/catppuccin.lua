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
      neotree = {
        enabled = true,
        show_root = false,
        transparent_panel = true,
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
    WhichKeyFloat = { link = "NormalFloat" },
    SpellBad = { fg = cp.red, style = "italic,undercurl" },
    SpellCap = { fg = cp.red, style = "italic,undercurl" },
    SpellLocal = { fg = cp.red, style = "italic,undercurl" },
    SpellRare = { fg = cp.red, style = "italic,undercurl" },
    -- SpellBad = { fg = cp.maroon },
    -- SpellCap = { fg = cp.peach },
    -- SpellLocal = { fg = cp.lavender },
    -- SpellRare = { fg = cp.teal },
  })

  -- NvChad Telescope theme (adapted from https://github.com/olimorris/onedarkpro.nvim/issues/31#issue-1160545258)
  local enable_nvchad_theme = true
  if enable_nvchad_theme then
    local telescope_results = cp.black2
    local telescope_prompt = cp.black3
    local fg = cp.gray1
    local purple = cp.green -- or mauve

    catppuccin.remap({
      TelescopeBorder = { fg = telescope_results, bg = telescope_results },
      TelescopePromptBorder = { fg = telescope_prompt, bg = telescope_prompt },
      TelescopePromptCounter = { fg = fg },
      TelescopePromptNormal = { fg = fg, bg = telescope_prompt },
      TelescopePromptPrefix = { fg = purple, bg = telescope_prompt },
      TelescopePromptTitle = { fg = telescope_prompt, bg = purple },
      TelescopePreviewTitle = { fg = telescope_prompt, bg = purple },
      TelescopeResultsTitle = { fg = telescope_results, bg = telescope_results },
      TelescopeMatching = { fg = purple },
      TelescopeNormal = { bg = telescope_results },
      TelescopeSelection = { bg = telescope_prompt },
    })
  end

  vim.cmd("colorscheme catppuccin")
end
