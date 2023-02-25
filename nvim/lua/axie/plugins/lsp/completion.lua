local M = {}

local DEFAULT_PRIORITY = 2

function M.config()
  -- setup cmp
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local sources = {
    -- copilot = { label = "Copilot", priority = 4 },
    nvim_lsp = { label = "LSP", priority = 3 },
    buffer = { label = "Buffer", priority = 1 },
    luasnip = { label = "LuaSnip", priority = 5 },
    path = { label = "Path" },
    calc = { label = "Calc" },
    emoji = { label = "Emoji" },
    spell = { label = "Spell", priority = 1 },
    latex_symbols = { label = "LaTeX" },
    npm = { label = "NPM" },
    git = { label = "Git" },
    -- cmdline = { label = "[Cmd]" },
    orgmode = { label = "Org" },
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
    ["<C-e>"] = {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp_map(cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    })),
    -- Toggle cmp menu
    -- ["<C-Space>"] = cmp_map(cmp.mapping.complete()),
    ["<C-Space>"] = {
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
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-z>", true, true, true), "ni", true)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "tn", false)
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
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "tn", false)
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
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({
        mode = "symbol",
        before = function(entry, vim_item)
          local source = sources[entry.source.name]
          vim_item.kind = source.kind or vim_item.kind
          vim_item.menu = "[" .. source.label .. "]"
          -- vim_item.menu = source.label
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
end

return M
