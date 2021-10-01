-- https://github.com/hrsh7th/nvim-cmp --

return function()
  local cmp = require("cmp")
  vim.o.completeopt = "menu,menuone,noselect"

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
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
      ["<Tab>"] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          return feedkey("<C-n>", "n")
        else
          return fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          return feedkey("<C-p>", "n")
        else
          return fallback()
        end
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "vsnip" },
      { name = "path" },
      { name = "calc" },
      { name = "emoji" },
      { name = "spell" },
      { name = "latex_symbols" },
      -- { name = "treesitter" },
      -- { name = "vim-dadbod-completion" },
    },
    formatting = {
      deprecated = true,
      format = function(entry, vim_item)
        vim_item.kind = require("lspkind").presets.default[vim_item.kind]

        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          buffer = "[Buffer]",
          vsnip = "[Vsnip]",
          path = "[Path]",
          calc = "[Calc]",
          emoji = "[Emoji]",
          spell = "[Spell]",
          latex_symbols = "[LaTeX]",
          -- treesitter = "[TS]",
          -- ["vim-dadbod-completion"] = "[DB]",
        })[entry.source.name]

        return vim_item
      end,
    },
  })

  -- Setup lspconfig.
  -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
  --   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- }
end
