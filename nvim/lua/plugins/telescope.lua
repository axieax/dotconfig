-- NOTE: even .gitignore ignored now
local M = {}

local current_buffer = vim.api.nvim_buf_get_name(0)
local is_directory = function(buf)
  return vim.fn.isdirectory(buf) == 1
end
local cwd = vim.fn.getcwd()

function M.file_search(from_autocmd)
  if current_buffer and is_directory(current_buffer) then
    -- Current buffer is a directory
    require("telescope.builtin").find_files({
      search_dirs = { cwd },
      hidden = true,
      file_ignore_patterns = { ".git" },
    })
  elseif not from_autocmd then
    -- Vim rooter sets Git project scope anyways
    require("telescope.builtin").find_files({
      hidden = true,
    })
  end
end

-- File explorer wrapper which shows hidden files by default,
-- and opens the file explorer to the directory that the
-- current buffer points to if it is a directory
-- NOTE: press <C-e> after query to create new file/directory
function M.explorer()
  if current_buffer and is_directory(current_buffer) then
    require("telescope.builtin").file_browser({
      cwd = current_buffer,
      hidden = true,
      file_ignore_patterns = { ".git" },
    })
  else
    require("telescope.builtin").file_browser({
      hidden = true,
      file_ignore_patterns = { ".git" },
    })
  end
end

function M.dotconfig()
  require("telescope.builtin").find_files({
    search_dirs = { "~/dotconfig" },
    hidden = true,
    file_ignore_patterns = { ".git" },
  })
end

function M.code_action()
  local ft = vim.bo.filetype
  if ft == "java" then
    require("jdtls").code_action()
  else
    require("telescope.builtin").lsp_code_actions()
  end
end

function M.setup()
  -- telescope setup mappings table - inside telescope overlay
  -- TODO: overwrite dotfiles? action for opening current file in native file explorer?
  require("telescope").setup({
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.7,
        },
        vertical = {
          prompt_position = "top",
        },
      },
    },
  })

  -- Extensions
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("dap")

  -- Can Telescope file browser create/move/delete files?
end

return M
