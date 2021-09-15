-- https://github.com/vuki656/package-info.nvim --
return function()
  local map = require("utils").map
  require("package-info").setup({})
  -- Keybinds
  -- Show package versions
  map({ "n", "<space>ps", "<cmd>:lua require'package-info'.show()<CR>" })
  -- Hide package versions
  map({ "n", "<space>pc", "<cmd>:lua require'package-info'.hide()<CR>" })
  -- TODO: toggle
  -- Update package on line
  map({ "n", "<space>pu", "<cmd>:lua require'package-info'.update()<CR>" })
  -- Delete package on line
  map({ "n", "<space>pd", "<cmd>:lua require'package-info'.delete()<CR>" })
  -- Install a new package
  map({ "n", "<space>pi", "<cmd>:lua require'package-info'.install()<CR>" })
  -- Reinstall dependencies
  map({ "n", "<space>pr", "<cmd>:lua require'package-info'.reinstall()<CR>" })
  -- Install a different package version
  map({ "n", "<space>pp", "<cmd>:lua require'package-info'.change_version()<CR>" })
end
