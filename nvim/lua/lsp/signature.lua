-- https://github.com/ray-x/lsp_signature.nvim --

return function()
  require("lsp_signature").setup({
    bind = true,
    handler_opts = {
      border = "none",
    },
    trigger_on_newline = true,
    padding = " ",
    transparency = 20,
    toggle_key = "<C-k>",
  })
end
