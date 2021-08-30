M = {}

function M.debug_test()
	local ft = vim.bo.filetype
	if ft == "python" then
		require("dap-python").test_method()
	elseif ft == "java" then
		require("jdtls").test_nearest_method()
	end
end

return M
