-- https://github.com/hrsh7th/nvim-cmp --

-- TODO: add toggle tabnine
-- BUG: no function signatures, conflicts with autopairs
local TABNINE_ENABLED = false
local DEFAULT_PRIORITY = 2

return function()
  -- setup vsnip directory
  vim.g.vsnip_snippet_dir = "~/.config/nvim/lua/lsp/snippets"

  -- setup cmp
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  vim.o.completeopt = "menu,menuone,noselect"

  local sources = {
    nvim_lsp = { label = "[LSP]" },
    nvim_lua = { label = "[Lua]" },
    buffer = { label = "[Buffer]", priority = 1 },
    vsnip = { label = "[Vsnip]", priority = 4 },
    path = { label = "[Path]" },
    calc = { label = "[Calc]" },
    emoji = { label = "[Emoji]" },
    spell = { label = "[Spell]", priority = 1 },
    latex_symbols = { label = "[LaTeX]" },
    cmp_tabnine = { label = "[T9]", kind = "", priority = 3 },
    -- treesitter = "[TS]",
    -- ["vim-dadbod-completion"] = "[DB]",
  }

  local source_config = {}
  for source_name, source_settings in pairs(sources) do
    -- not (source_name == "cmp_tabnine" and not TABNINE_ENABLED)
    if source_name ~= "cmp_tabnine" or TABNINE_ENABLED then
      table.insert(source_config, {
        name = source_name,
        priority = source_settings.priority or DEFAULT_PRIORITY,
      })
    end
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
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      -- ["<CR>"] = cmp.mapping.confirm({ select = false }), -- overwritten in pairs.lua
      ["<S-CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
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
  })

  -- tabnine setup
  if TABNINE_ENABLED then
    local tabnine = require("cmp_tabnine.config")
    tabnine:setup({
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "..",
    })
  end

  -- Setup lspconfig.
  -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
  --   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- }
end
