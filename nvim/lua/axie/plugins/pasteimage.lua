local M = {}

function M.config()
  local relative_dir = vim.fn.fnamemodify(vim.fn.expand("%"), ":h")
  local request_img_name = function()
    vim.fn.inputsave()
    local name = vim.fn.input("Image Name: ")
    vim.fn.inputrestore()
    return require("axie.utils").fallback(name, os.date("%Y-%m-%d-%H-%M-%S"))
  end

  require("clipboard-image").setup({
    default = {
      img_dir = "images",
      img_dir_txt = "images",
      img_name = request_img_name,
    },
    markdown = {
      -- img_dir = { relative_dir, "images" }, -- relative to current buffer file
      img_dir = relative_dir .. "/images", -- relative to current buffer file
    },
  })
end

return M
