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
  local map = require("utils").map
  map({ "n", "<Space>ff", "<cmd>lua require('plugins.telescope').file_search(false)<cr>" })
  map({ "n", "<Space>fc", "<cmd>lua require('plugins.telescope').dotconfig()<cr>" })
  map({ "n", "<Space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" })
  map({ "n", "<Space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" })
  map({ "n", "<Space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" })
  map({ "n", "<Space>fe", "<cmd>lua require('plugins.telescope').explorer()<cr>" })
  vim.cmd("autocmd VimEnter * lua require('plugins.telescope').file_search(true)")
  map({ "n", "<Space>fH", "<cmd>lua require('telescope.builtin').vim_options()<cr>" })
  map({ "n", "<C-_>", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" }) -- control slash NOTE: inverse order
  map({ "n", "<Space>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>" })
  map({ "n", "<Space>fr", "<cmd>lua require('telescope.builtin').registers()<cr>" })
  map({ "n", "<Space>ft", "<cmd>lua require('telescope.builtin').colorscheme()<cr>" })
  map({ "n", "<Space>fm", "<cmd>lua require('telescope.builtin').man_pages()<cr>" })
  map({ "n", "<Space>fs", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" })
  map({ "n", "<Space>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>" })
  map({ "n", "<Space>f/", "<cmd>lua require('telescope.builtin').search_history()<cr>" })
  map({ "n", "<Space>f;", "<cmd>lua require('telescope.builtin').command_history()<cr>" })
  map({ "n", "<Space>fq", "<cmd>:TodoTrouble<CR>" })

  map({ "n", "<Space>gs", "<cmd>lua require('telescope.builtin').git_stash()<cr>" })
  map({ "n", "<Space>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>" })
  map({ "n", "<Space>g?", "<cmd>lua require('telescope.builtin').git_status()<cr>" })
  map({ "n", "<Space>gc", "<cmd>lua require('telescope.builtin').git_bcommits()<cr>" })
  map({ "n", "<Space>gC", "<cmd>lua require('telescope.builtin').git_commits()<cr>" })

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
