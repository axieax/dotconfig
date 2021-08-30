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
			search_dirs = { current_buffer, cwd },
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

return M
