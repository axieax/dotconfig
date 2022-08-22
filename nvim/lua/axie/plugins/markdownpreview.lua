local M = {}

function M.run()
  vim.fn["mkdp#util#install"]()
end

function M.setup()
  local filetype_map = require("axie.utils").filetype_map
  filetype_map("markdown", "n", ",O", "<Cmd>MarkdownPreview<CR>")
end

return M
