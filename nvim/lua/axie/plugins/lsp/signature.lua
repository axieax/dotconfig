local M = {}

function M.on_attach(bufnr)
  require("lsp_signature").on_attach({
    -- general options
    always_trigger = false,
    toggle_key = "<A-k>",

    -- floating window
    padding = " ",
    transparency = 20,
    handler_opts = { border = "rounded" },
  }, bufnr)
end

return M
