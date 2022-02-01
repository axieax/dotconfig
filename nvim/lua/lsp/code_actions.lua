local M = {}

-- TODO: CodeActionMenu

function M.default(...)
  local ft = vim.bo.filetype
  if ft == "java" then
    return M.builtin(...)
  else
    return M.telescope(...)
  end
end

local no_code_actions_notify = function()
  vim.api.nvim_echo({ { " No code actions available", "WarningMsg" } }, false, {})
end

---Sort and filter lsp results
function M.update_results(lsp_results, ignore_null_ls)
  local results = {}
  local null_results = {}

  for client_id, result in ipairs(lsp_results) do
    local client = vim.lsp.get_client_by_id(client_id)
    local is_null = client.name == "null-ls"

    -- Filter null-ls actions as requested
    if not is_null or (is_null and not ignore_null_ls) then
      if is_null then
        table.insert(null_results, result)
      else
        table.insert(results, result)
      end
    end
  end

  -- Sort null-ls actions to the end
  return vim.list_extend(results, null_results)
end

---Builtin vim.lsp.buf.code_actions
function M.builtin(ignore_null_ls, context)
  ignore_null_ls = ignore_null_ls or false

  -- Attach to vim.lsp.buf_request_all
  local buf_request_all = vim.lsp.buf_request_all
  vim.lsp.buf_request_all = function(bufnr, method, params, callback)
    return buf_request_all(bufnr, method, params, function(lsp_results)
      vim.lsp.buf_request_all = buf_request_all
      local results = M.update_results(lsp_results, ignore_null_ls)
      return callback(results)
    end)
  end

  vim.lsp.buf.code_action(context)
end

---Telescope lsp_code_actions
function M.telescope(ignore_null_ls, opts)
  ignore_null_ls = ignore_null_ls or false

  -- Override vim.notify
  local original_notify = vim.notify
  vim.notify = no_code_actions_notify

  -- Attach to vim.lsp.buf_request_sync
  local buf_request_sync = vim.lsp.buf_request_sync
  vim.lsp.buf_request_sync = function(...)
    local lsp_results, err = buf_request_sync(...)
    vim.lsp.buf_request_sync = buf_request_sync
    if err then
      return nil, err
    end

    return M.update_results(lsp_results, ignore_null_ls), nil
  end

  require("telescope.builtin").lsp_code_actions(opts)
  vim.notify = original_notify
end

return M
