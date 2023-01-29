local M = {}

M.cmd = { "Catppuccin", "CatppuccinCompile" }

function M.config()
  -- highlight group overrides
  vim.g.catppuccin_flavour = "mocha"
  local catppuccin = require("catppuccin")
  local cp = require("catppuccin.palettes").get_palette()
  local ucolors = require("catppuccin.utils.colors")

  local float_bg = cp.base
  local remaps = {
    NormalFloat = { bg = float_bg }, -- NOTE: catppuccin needs a bg colour
    CursorLine = { bg = ucolors.darken(cp.surface0, 0.64, cp.base) },
    ColorColumn = { link = "CursorLine" },
    WhichKeyFloat = { link = "NormalFloat" },
    SpellBad = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellCap = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellLocal = { fg = cp.red, style = { "italic", "undercurl" } },
    SpellRare = { fg = cp.red, style = { "italic", "undercurl" } },
    CmpItemMenu = { fg = cp.surface2 },
    Pmenu = { bg = cp.surface0 },
    WinBar = { bg = float_bg },
    WinBarNC = { bg = float_bg },
    WinBarModified = { fg = cp.yellow, bg = float_bg }, -- same as BufferCurrentMod
    NavicIconsFileNC = { fg = cp.flamingo, bg = float_bg },
    -- VertSplit = { fg = cp.overlay1 },
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

  catppuccin.setup({
    compile = { enabled = true },
    dim_inactive = { enabled = false },
    transparent_background = true,
    integrations = {
      aerial = true,
      barbar = true,
      beacon = true,
      bufferline = false,
      cmp = true,
      coc_nvim = false,
      dap = {
        enabled = true,
        enable_ui = true,
      },
      dashboard = false, -- startify?
      feline = false,
      fern = false,
      fidget = false, -- prefer default colours
      gitgutter = false,
      gitsigns = true,
      harpoon = false,
      hop = false,
      illuminate = false,
      indent_blankline = {
        enabled = true,
        -- colored_indent_levels = true,
      },
      leap = true,
      lightspeed = false,
      lsp_saga = false,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      mini = false,
      native_lsp = { enabled = true },
      navic = {
        enabled = true,
        custom_bg = float_bg,
      },
      neogit = true,
      neotest = true,
      neotree = {
        enabled = true,
        show_root = false,
        transparent_panel = true,
      },
      noice = false,
      notify = true,
      nvimtree = false,
      overseer = false,
      pounce = false,
      symbols_outline = true,
      telekasten = true,
      telescope = true,
      treesitter = true,
      treesitter_context = false,
      ts_rainbow = true,
      vim_sneak = false,
      vimwiki = true,
      which_key = true,
    },
    custom_highlights = remaps,
  })

  vim.api.nvim_cmd({ cmd = "colorscheme", args = { "catppuccin" } }, {})
end

return M
