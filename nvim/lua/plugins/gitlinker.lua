-- https://github.com/ruifm/gitlinker.nvim --
return function()
  local map = require("utils").map
  require("gitlinker").setup({
    mappings = "<space>gy",
  })
  -- Open line link in browser
  map({
    "n",
    "<space>gw",
    "<cmd>lua require'gitlinker'.get_buf_range_url('n', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
  })
  map({
    "v",
    "<space>gw",
    ":lua require'gitlinker'.get_buf_range_url('v', {action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
  })

  -- Base repo url
  map({ "n", "<space>gY", "<cmd>lua require'gitlinker'.get_repo_url()<CR>" })
  map({
    "n",
    "<space>gW",
    "<cmd>lua require'gitlinker'.get_repo_url({action_callback = require'gitlinker.actions'.open_in_browser})<CR>",
  })
end
