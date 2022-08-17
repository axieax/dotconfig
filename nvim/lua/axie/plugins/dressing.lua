local M = {}

function M.config()
  require("dressing").setup({
    input = {
      get_config = function()
        local disabled_filetypes = { "neo-tree" }
        if vim.tbl_contains(disabled_filetypes, vim.bo.filetype) then
          return { enabled = false }
        end
      end,
    },
  })
end

return M
