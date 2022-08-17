local M = {}

function M.config()
  require("lsp_signature").setup({
    -- general options
    always_trigger = "true",
    toggle_key = "<a-k>",

    -- floating window
    padding = " ",
    transparency = 20,
    handler_opts = {
      -- border = "none",
      border = "rounded",
    },
  })
end

return M
