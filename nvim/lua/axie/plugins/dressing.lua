-- https://github.com/stevearc/dressing.nvim --

return function()
  require("dressing").setup({
    select = {
      format_item_override = {
        codeaction = function(action_tuple)
          local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
          local client = vim.lsp.get_client_by_id(action_tuple[1])
          return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
        end,
      },
    },
  })
end
