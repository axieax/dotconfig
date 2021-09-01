-- https://github.com/lewis6991/gitsigns.nvim --
return function()
  local map = require("utils").map
  require("gitsigns").setup({
    keymaps = {
      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
    },
  })
  -- Toggle Git blame
  -- TODO: customise virtual text colour. angry prefix
  map({ "n", "<space>gb", "<cmd>:Gitsigns toggle_current_line_blame<CR>" })
end
