-- https://github.com/catppuccin/nvim --

return function()
  -- highlight group overrides
  local cp = require("catppuccin.palettes").get_palette()

  local remaps = {
    NormalFloat = { bg = cp.base }, -- NOTE: catppuccin needs a bg colour
    ColorColumn = { link = "CursorLine" },
    WhichKeyFloat = { link = "NormalFloat" },
    SpellBad = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellCap = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellLocal = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellRare = { fg = cp.red, style = { "italic", "undercurl" } },
    CmpItemMenu = { fg = cp.surface2 },
    -- SpellBad = { fg = cp.maroon },
    -- SpellCap = { fg = cp.peach },
    -- SpellLocal = { fg = cp.lavender },
    -- SpellRare = { fg = cp.teal },
  }

  -- NvChad Telescope theme (adapted from https://github.com/olimorris/onedarkpro.nvim/issues/31#issue-1160545258)
  if require("axie.utils.config").nvchad_theme then
    local telescope_results = cp.base
    -- local telescope_prompt = cp.surface0
    local telescope_prompt = "#302D41" -- black3 from original palette
    local fg = cp.surface2
    local purple = cp.green -- or mauve
    remaps = vim.tbl_extend("force", remaps, {
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

  local catppuccin = require("catppuccin")
  vim.g.catppuccin_flavour = "mocha"
  vim.g.catppuccin_override_colors = remaps
  catppuccin.setup({
    compile = { enabled = true },
    dim_inactive = { enabled = false },
    transparent_background = true,
    integrations = {
      treesitter = true,
      native_lsp = { enabled = true },
      coc_nvim = false,
      lsp_trouble = true,
      cmp = true,
      lsp_saga = false,
      gitgutter = false,
      gitsigns = true,
      leap = false,
      telescope = true,
      nvimtree = { enabled = false },
      neotree = {
        enabled = true,
        show_root = false,
        transparent_panel = true,
      },
      dap = {
        enabled = true,
        enable_ui = true,
      },
      which_key = true,
      indent_blankline = {
        enabled = true,
        -- colored_indent_levels = true,
      },
      dashboard = false, -- startify?
      neogit = true,
      vim_sneak = false,
      fern = false,
      barbar = true,
      bufferline = true,
      markdown = true,
      lightspeed = true,
      ts_rainbow = true,
      hop = true,
      notify = true,
      telekasten = true,
      symbols_outline = true,
      mini = false,
      aerial = true,
      vimwiki = true,
      beacon = true,
    },
    custom_highlights = remaps,
  })

  -- Create an autocmd User PackerCompileDone to update it every time packer is compiled
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerCompileDone",
    callback = function()
      vim.cmd("CatppuccinCompile")
      vim.defer_fn(function()
        vim.cmd("colorscheme catppuccin")
      end, 50) -- Debounced for live reloading
    end,
  })

  vim.cmd("colorscheme catppuccin")
end
