-- https://github.com/EdenEast/nightfox.nvim --

return function()
  local nightfox = require("nightfox")
  nightfox.setup({
    fox = "duskfox",
    transparent = true,
    alt_nc = true,
  })
  -- nightfox.load()
end
