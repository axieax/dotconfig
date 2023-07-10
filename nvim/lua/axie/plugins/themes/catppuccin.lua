local M = {}

M.cmd = { "Catppuccin", "CatppuccinCompile" }

function M.config()
  require("catppuccin").setup({
    flavour = "mocha",
    compile = { enabled = true },
    dim_inactive = { enabled = false },
    transparent_background = true,
    integrations = {
      aerial = true,
      barbar = true,
      -- barbecue = false,
      beacon = true,
      bufferline = false,
      cmp = true,
      coc_nvim = false,
      dap = {
        enabled = true,
        enable_ui = true,
      },
      dashboard = false, -- startify?
      dropbar = {
        enabled = true,
        color_mode = false,
      },
      feline = false,
      fern = false,
      fidget = false, -- prefer default colours
      gitgutter = false,
      gitsigns = true,
      harpoon = false,
      headlines = false,
      hop = false,
      illuminate = false,
      indent_blankline = {
        enabled = true,
        -- colored_indent_levels = true,
      },
      leap = true,
      lightspeed = false,
      lsp_saga = false,
      lsp_trouble = false,
      markdown = true,
      mason = true,
      mini = false,
      native_lsp = {
        enabled = true,
        underlines = {
          -- errors = { "undercurl" },
          -- hints = { "undercurl" },
          -- warnings = { "undercurl" },
          -- information = { "undercurl" },
        },
      },
      navic = {
        enabled = true,
        -- cp.base
        custom_bg = "#1E1E2E",
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
      octo = false,
      overseer = false,
      pounce = false,
      rainbow_delimiters = false,
      sandwich = false,
      semantic_tokens = true,
      symbols_outline = false,
      telekasten = false,
      telescope = { enabled = true },
      treesitter = true,
      treesitter_context = false,
      ts_rainbow = true,
      ts_rainbow2 = false,
      vim_sneak = false,
      vimwiki = true,
      which_key = true,
    },
    custom_highlights = function(colours)
      local float_bg = colours.base
      local remaps = {
        NormalFloat = { bg = float_bg }, -- NOTE: catppuccin needs a bg colour
        ColorColumn = { link = "CursorLine" },
        SpellBad = { fg = colours.red, style = { "italic", "undercurl" } },
        SpellCap = { fg = colours.red, style = { "italic", "undercurl" } },
        SpellLocal = { fg = colours.red, style = { "italic", "undercurl" } },
        SpellRare = { fg = colours.red, style = { "italic", "undercurl" } },
        CmpItemMenu = { fg = colours.surface2 },
        Pmenu = { bg = colours.surface0 },
        WinBar = { bg = float_bg },
        WinBarNC = { bg = float_bg },
        WinBarModified = { fg = colours.yellow, bg = float_bg }, -- same as BufferCurrentMod
        NavicIconsFileNC = { fg = colours.flamingo, bg = float_bg },
        ["@parameter"] = { fg = colours.flamingo },
        -- VertSplit = { fg = cp.overlay1 },
        -- SpellBad = { fg = cp.maroon },
        -- SpellCap = { fg = cp.peach },
        -- SpellLocal = { fg = cp.lavender },
        -- SpellRare = { fg = cp.teal },
      }

      -- NvChad Telescope theme (adapted from https://github.com/olimorris/onedarkpro.nvim/issues/31#issue-1160545258)
      if require("axie.utils.config").nvchad_theme then
        local telescope_results = colours.base
        -- local telescope_prompt = cp.surface0
        local telescope_prompt = "#302D41" -- black3 from original palette
        local fg = colours.surface2
        local purple = colours.green -- or mauve
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
      return remaps
    end,
  })

  vim.api.nvim_cmd({ cmd = "colorscheme", args = { "catppuccin" } }, {})
end

return M
