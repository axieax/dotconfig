local M = {}


function M.file_search(from_autocmd)
	local current_buffer = vim.api.nvim_buf_get_name(0)
	if current_buffer and vim.fn.isdirectory(current_buffer) == 1 then
		-- Current buffer is a directory
		require('telescope.builtin').find_files {
			hidden = true,
			search_dirs = { current_buffer }, -- add cwd?
		}
	elseif not from_autocmd then
		-- Vim rooter sets Git project scope anyways
		require('telescope.builtin').find_files {
			hidden = true,
		}
	end
end



-- File explorer wrapper which shows hidden files by default,
-- and opens the file explorer to the directory that the
-- current buffer points to if it is a directory
function M.explorer()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	if current_buffer and vim.fn.isdirectory(current_buffer) == 1 then
		require('telescope.builtin').file_browser {
			hidden = true,
			cwd = current_buffer,
		}
	else
		require('telescope.builtin').file_browser {
			hidden = true,
		}
	end
end



return M
