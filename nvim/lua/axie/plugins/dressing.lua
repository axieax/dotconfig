-- https://github.com/stevearc/dressing.nvim --

return function()
  require("dressing").setup({
    input = {
      get_config = function()
        if vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree" then
          return { enabled = false }
        end
      end,
    },
    select = {
      format_item_override = {
        codeaction = function(action_tuple)
          print(vim.inspect(action_tuple))
          local client = vim.lsp.get_client_by_id(action_tuple[1])
          local entry = action_tuple[2]
          local max_widths = entry.max_widths

          local entry_display = require("telescope.pickers.entry_display")
          local displayer = entry_display.create({
            separator = " ",
            items = {
              { width = max_widths.idx + 1 }, -- +1 for ":" suffix
              { width = max_widths.title },
              { width = max_widths.client_name },
            },
          })

          return displayer({
            { entry.idx .. ":", "TelescopePromptPrefix" },
            { entry.title },
            { client.name, "TelescopeResultsComment" },
          })

          -- local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
          -- local client = vim.lsp.get_client_by_id(action_tuple[1])
          -- return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
        end,
      },
    },
  })
end
