-- https://github.com/hrsh7th/nvim-cmp --

-- TODO: add toggle tabnine
-- BUG: tabnine: no function signatures, conflicts with autopairs
-- BUG: command mode completion affects vim-cool search highlights

local DEFAULT_PRIORITY = 2

return function()
  -- setup cmp
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local sources = {
    nvim_lsp = { label = "[LSP]", priority = 3 },
    nvim_lua = { label = "[Lua]", priority = 3 },
    buffer = { label = "[Buffer]", priority = 1 },
    luasnip = { label = "[LSnip]", priority = 5 },
    path = { label = "[Path]" },
    calc = { label = "[Calc]" },
    emoji = { label = "[Emoji]" },
    spell = { label = "[Spell]", priority = 1 },
    latex_symbols = { label = "[LaTeX]" },
    -- cmp_tabnine = { label = "[T9]", kind = "", priority = 4 },
    npm = { label = "[NPM]" },
    git = { label = "[Git]" },
    -- cmdline = { label = "[Cmd]" },
    orgmode = { label = "[Org]" },
    -- treesitter = "[TS]",
    -- ["vim-dadbod-completion"] = "[DB]",
  }

  local source_config = {}
  for source_name, source_settings in pairs(sources) do
    table.insert(source_config, {
      name = source_name,
      priority = source_settings.priority or DEFAULT_PRIORITY,
    })
  end

  local function cmp_map(...)
    return cmp.mapping(..., { "i", "c" })
  end

  local function filter_mode(mappings, mode)
    local res = {}
    for k, v in pairs(mappings) do
      if v[mode] then
        res[k] = { [mode] = v[mode] }
      end
    end
    return res
  end

  local mappings = {
    ["<C-d>"] = cmp_map(cmp.mapping.scroll_docs(-4)),
    ["<C-f>"] = cmp_map(cmp.mapping.scroll_docs(4)),
    ["<C-Space>"] = cmp_map(cmp.mapping.complete()),
    ["<C-e>"] = {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp_map(cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    })),
    -- Toggle cmp menu
    ["<a-k>"] = {
      i = function()
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end,
      c = function()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end,
    },
    ["<Tab>"] = {
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
    ["<S-Tab>"] = {
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
  }

  cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert(filter_mode(mappings, "i")),
    sources = source_config,
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        before = function(entry, vim_item)
          local source = sources[entry.source.name]
          vim_item.kind = source.kind or vim_item.kind
          vim_item.menu = source.label
          return vim_item
        end,
      }),
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    experimental = {
      ghost_text = true, -- preview
    },
  })

  -- tabnine setup
  -- local tabnine = require("cmp_tabnine.config")
  -- tabnine:setup({
  --   max_lines = 1000,
  --   max_num_results = 20,
  --   sort = true,
  --   run_on_every_keystroke = true,
  --   snippet_placeholder = "..",
  -- })

  -- npm
  require("cmp-npm").setup()

  -- git
  require("cmp_git").setup({
    filetypes = { "*" },
  })

  -- Setup autopairs
  require("nvim-autopairs").setup({
    -- insert mode "alt-e"
    -- NOTE: vim surround visual selection: S_ as well
    fast_wrap = {},
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  -- Command mode completion
  local cmdline_mappings = cmp.mapping.preset.cmdline(filter_mode(mappings, "c"))
  local cmdline_view = { entries = "wildmenu" }

  -- Use buffer source for `/`.
  cmp.setup.cmdline("/", {
    mapping = cmdline_mappings,
    view = cmdline_view,
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(":", {
    mapping = cmdline_mappings,
    view = cmdline_view,
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      -- { name = "cmdline" },
    }),
  })

  -- Highlights
  -- INSPO: https://github.com/Mofiqul/dracula.nvim/blob/a8106b9370338fbec149236132fd0861d5bb6265/lua/dracula/init.lua#L375-L408
  -- NOTE: may get overriden by some colorschemes
  local highlight_links = {
    -- { "CmpItemAbbrDeprecated" },
    -- { "CmpItemAbbrMatch" },
    -- { "CmpItemAbbrMatchFuzzy" },
    { "CmpItemKindMethod", "TSMethod" },
    { "CmpItemKindText", "TSText" },
    { "CmpItemKindFunction", "TSFunction" },
    { "CmpItemKindConstructor", "TSType" },
    { "CmpItemKindVariable", "TSVariable" },
    { "CmpItemKindClass", "TSType" },
    { "CmpItemKindInterface", "TSType" },
    { "CmpItemKindModule", "TSNamespace" },
    { "CmpItemKindProperty", "TSProperty" },
    { "CmpItemKindOperator", "TSOperator" },
    { "CmpItemKindReference", "TSParameterReference" },
    { "CmpItemKindUnit", "TSField" },
    { "CmpItemKindValue", "TSField" },
    { "CmpItemKindField", "TSField" },
    { "CmpItemKindEnum", "TSField" },
    { "CmpItemKindKeyword", "TSKeyword" },
    { "CmpItemKindSnippet", "TSText" },
    { "CmpItemKindColor", "cssColor" },
    { "CmpItemKindFile", "TSURI" },
    { "CmpItemKindFolder", "TSURI" },
    { "CmpItemKindEvent", "TSConstant" },
    { "CmpItemKindEnumMember", "TSField" },
    { "CmpItemKindConstant", "TSConstant" },
    { "CmpItemKindStruct", "TSStructure" },
    { "CmpItemKindTypeParameter", "TSParameter" },
  }

  local override_default = false
  for _, mapping in ipairs(highlight_links) do
    local kind, link = unpack(mapping)
    kind = require("axie.utils").ternary(override_default, kind .. "Default", kind)
    vim.cmd(string.format("highlight link %s %s", kind, link))
  end
end
