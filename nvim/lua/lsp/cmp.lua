-- https://github.com/hrsh7th/nvim-cmp --

-- TODO: add toggle tabnine
-- BUG: tabnine: no function signatures, conflicts with autopairs
-- BUG: command mode completion affects vim-cool search highlights

local DEFAULT_PRIORITY = 2

return function()
  -- setup vsnip directory
  vim.g.vsnip_snippet_dir = "~/.config/nvim/lua/lsp/snippets"

  -- setup cmp
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  vim.o.completeopt = "menu,menuone,noselect"

  local sources = {
    nvim_lsp = { label = "[LSP]", priority = 3 },
    nvim_lua = { label = "[Lua]", priority = 3 },
    buffer = { label = "[Buffer]", priority = 1 },
    vsnip = { label = "[Vsnip]", priority = 5 },
    path = { label = "[Path]" },
    calc = { label = "[Calc]" },
    emoji = { label = "[Emoji]" },
    spell = { label = "[Spell]", priority = 1 },
    latex_symbols = { label = "[LaTeX]" },
    -- cmp_tabnine = { label = "[T9]", kind = "", priority = 4 },
    npm = { label = "[NPM]" },
    cmp_git = { label = "[Git]" },
    cmdline = { label = "[Cmd]" },
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

  cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        -- Vsnip
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp_map(cmp.mapping.scroll_docs(-4)),
      ["<C-f>"] = cmp_map(cmp.mapping.scroll_docs(4)),
      ["<C-Space>"] = cmp_map(cmp.mapping.complete()),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<CR>"] = cmp_map(cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      })),
      ["<S-CR>"] = cmp_map(cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      })),
      -- Toggle cmp menu
      ["<C-k>"] = cmp.mapping({
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
      }),
      ["<Tab>"] = cmp_map(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          -- local copilot_keys = vim.fn["copilot#Accept"]()
          -- if copilot_keys ~= "" then
          --   vim.api.nvim_feedkeys(copilot_keys, "i", true)
          -- else
          --   fallback()
          -- end
          fallback()
        end
      end),
      ["<S-Tab>"] = cmp_map(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end),
    },
    sources = source_config,
    formatting = {
      deprecated = true,
      format = function(entry, vim_item)
        local source = sources[entry.source.name]
        vim_item.kind = source.kind or lspkind.presets.default[vim_item.kind]
        vim_item.menu = source.label
        return vim_item
      end,
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
      -- preview
      ghost_text = true,
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
  require("cmp-npm").setup({})

  -- git
  require("cmp_git").setup({
    filetypes = { "*" },
  })

  -- Setup lspconfig.
  -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
  --   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- }

  -- Setup autopairs
  require("nvim-autopairs").setup({
    -- insert mode "alt-e"
    -- NOTE: vim surround visual selection: S_ as well
    fast_wrap = {},
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  -- Command mode completion
  -- Use buffer source for `/`.
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      -- { name = "cmdline" },
    }),
  })
end
