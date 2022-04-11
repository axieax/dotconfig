-- https://github.com/ray-x/lsp_signature.nvim --

return function()
  require("lsp_signature").setup({
    -- general options
    always_trigger = "true",
    toggle_key = "<a-K>",

    -- floating window
    padding = " ",
    transparency = 20,
    handler_opts = {
      -- border = "none",
      border = "rounded",
    },
  })
end
