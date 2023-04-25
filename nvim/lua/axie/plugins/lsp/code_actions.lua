local M = {}

local no_code_actions_notify = function()
  vim.api.nvim_echo({ { "󰇸 No code actions available", "WarningMsg" } }, false, {})
end

---Filter lsp results
local function filter_null(lsp_results)
  for client_id, _ in pairs(lsp_results) do
    if vim.lsp.get_client_by_id(client_id).name == "null-ls" then
      lsp_results[client_id] = nil
      break
    end
  end
  return lsp_results
end

---Builtin vim.lsp.buf.code_actions
---@param ignore_null_ls boolean|nil @Optional parameter to ignore null-ls (default: false)
---@param context table|nil @Optional parameter to pass to vim.lsp.buf.code_actions
function M.native(ignore_null_ls, context)
  ignore_null_ls = ignore_null_ls or false

  -- Override vim.notify
  local original_notify = vim.notify
  vim.notify = no_code_actions_notify

  -- Attach to vim.lsp.buf_request_all
  local buf_request_all = vim.lsp.buf_request_all
  vim.lsp.buf_request_all = function(bufnr, method, params, callback)
    return buf_request_all(bufnr, method, params, function(lsp_results)
      vim.lsp.buf_request_all = buf_request_all
      if ignore_null_ls then
        lsp_results = filter_null(lsp_results)
      end

      local res = callback(lsp_results)
      vim.notify = original_notify
      return res
    end)
  end

  vim.lsp.buf.code_action(context)
end

return M
