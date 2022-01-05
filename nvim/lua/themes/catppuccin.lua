-- https://github.com/catppuccin/nvim --

return function()
  local catppuccin = require("catppuccin")
  catppuccin.setup({
    transparent_background = true,
    integrations = {
      lsp_trouble = true,
      cmp = true,
      lsp_saga = true,
      gitgutter = true,
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
  catppuccin.remap({
    ColorColumn = { link = "CursorLine" },
  })

  vim.cmd("colorscheme catppuccin")
end
