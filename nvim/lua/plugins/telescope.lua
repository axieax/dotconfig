-- NOTE: even .gitignore ignored now
local M = {}

local current_buffer = vim.api.nvim_buf_get_name(0)
local is_directory = function(buf)
  return vim.fn.isdirectory(buf) == 1
end
local cwd = vim.fn.getcwd()

function M.file_search()
  -- Vim rooter sets Git project scope anyways
  require("telescope.builtin").find_files({
    hidden = true,
    file_ignore_patterns = { ".git" },
  })
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
    -- require("telescope.builtin").lsp_code_actions()
    -- require("code_action_menu").open_code_action_menu()
    vim.cmd("CodeActionMenu")
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
    extensions = {
      media_files = {
        -- pip install ueberzug for images
        -- pdftoppm for pdf
        -- ffmpegthumbnailer for videos
        filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
        find_cmd = "rg",
      },
    },
  })

  -- Extensions
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("dap")
  require("telescope").load_extension("media_files")
  require("telescope").load_extension("neoclip")
  require("telescope").load_extension("notify")
  -- require("telescope").load_extension("node_modules")

  -- Can Telescope file browser create/move/delete files?

  -- context indicator
  require("nvim-biscuits").setup({
    on_events = { "CursorMoved", "CursorMovedI" },
    -- cursor_line_only = true,
    startup = false,
    default_config = {
      max_length = 24,
      min_distance = 4,
      prefix_string = " ﬌ ",
    },
  })
  vim.cmd([[highlight BiscuitColor ctermfg=cyan]])
  -- vim.api.nvim_set_hl(0, "BiscuitColor", { ctermfg = "cyan" })
  -- disable automatically
  require("nvim-biscuits").toggle_biscuits()
end

return M
