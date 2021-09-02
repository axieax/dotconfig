-- https://github.com/phaazon/hop.nvim --
return function()
  local map = require("utils").map
  require("hop").setup({
    -- keys = "etovxqpdygfblzhckisuran",
  })
  -- Keybinds
  map({ "n", "ghc", "<cmd>:HopChar1<CR>" })
  map({ "n", "ghC", "<cmd>:HopChar2<CR>" })
  map({ "n", "ghw", "<cmd>:HopWord<CR>" })
  map({ "n", "ghl", "<cmd>:HopLine<CR>" })
  map({ "n", "gh", "<cmd>:HopPattern<CR>" })
end
