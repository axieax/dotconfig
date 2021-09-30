-- https://github.com/hrsh7th/nvim-compe --

return function()
  local map = require("utils").map
  vim.o.completeopt = "menuone,noselect"

  require("compe").setup({
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    resolve_timeout = 800,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = {
      border = { "", "", "", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    },

    source = {
      -- Common
      path = true,
      buffer = true,
      tags = true,
      spell = true,
      calc = true,
      emoji = true,

      -- nvim-specific
      nvim_lsp = true,
      nvim_lua = true,

      -- External plugins
      vsnip = true,
      -- ultisnips = true;
      -- luasnip = true;
    },
  })

  map({ "i", "<C-Space>", "compe#complete()", expr = true })
  map({ "i", "<C-e>", "compe#close('<C-e>')", expr = true })
  map({ "i", "<C-f>", "compe#scroll({ 'delta': +4 })", expr = true })
  map({ "i", "<C-d>", "compe#scroll({ 'delta': -4 })", expr = true })
  map({ "i", "<CR>", [[compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })]], expr = true })
  -- vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true }) -- auto-import?

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-n>")
    else
      return t("<Tab>")
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-p>")
    else
      -- If <S-Tab> is not working in your terminal, change it to <C-h>
      return t("<S-Tab>")
    end
  end

  map({ "i", "<Tab>", "v:lua.tab_complete()", expr = true })
  map({ "s", "<Tab>", "v:lua.tab_complete()", expr = true })
  map({ "i", "<S-Tab>", "v:lua.s_tab_complete()", expr = true })
  map({ "s", "<S-Tab>", "v:lua.s_tab_complete()", expr = true })
end
