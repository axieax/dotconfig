-- https://github.com/ruifm/gitlinker.nvim --
return function()
  local map = require("utils").map
  require("gitlinker").setup({
    mappings = "<space>gy",
  })
  -- Open line link in browser (visual mode map)
  map({
    "v",
    "<space>gw",
    "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
  })
end
