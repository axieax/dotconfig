local M = {}

-- TODO: CodeActionMenu

function M.default(...)
  -- TODO: custom Telescope picker which uses generic builtin functionality
  local ft = vim.bo.filetype
  if ft == "java" then
    return M.builtin(...)
  else
    return M.builtin(...)
    -- return M.telescope(...)
  end
end

local no_code_actions_notify = function()
  vim.api.nvim_echo({ { " No code actions available", "WarningMsg" } }, false, {})
end

---Sort and filter lsp results
function M.update_results(lsp_results, ignore_null_ls)
  local results = {}
  local null_results = {}
  local max_widths = {
    idx = 0,
    title = 0,
    client_name = 0,
  }

  local num_actions = 0
  for client_id, result in ipairs(lsp_results) do
    -- print(vim.inspect(result))
    local client = vim.lsp.get_client_by_id(client_id)
    local is_null = client.name == "null-ls"

    -- Filter null-ls actions as requested
    local inserted = false
    if not is_null then
      inserted = true
      table.insert(results, result)
    elseif not ignore_null_ls then
      inserted = true
      table.insert(null_results, result)
    end

    -- Update max widths
    if inserted then
      for _, action in pairs(result.result or {}) do
        num_actions = num_actions + 1
        max_widths.idx = math.max(max_widths.idx, vim.fn.strdisplaywidth(num_actions))
        max_widths.title = math.max(max_widths.title, vim.fn.strdisplaywidth(action.title))
        max_widths.client_name = math.max(max_widths.client_name, vim.fn.strdisplaywidth(client.name))
      end
    end
  end

  -- Sort null-ls actions to the end
  vim.list_extend(results, null_results)

  -- TODO: add widths and idx for Telescope picker
  -- https://github.com/nvim-telescope/telescope.nvim/blob/762d49f60749eac75979202194ad0ee177977a74/lua/telescope/builtin/lsp.lua#L217-L219
  local idx = 1
  for _, result in ipairs(results) do
    for _, action in pairs(result.result or {}) do
      action.idx = idx
      action.max_widths = {}
      for k, _ in pairs(max_widths) do
        action.max_widths[k] = max_widths[k]
      end
      idx = idx + 1
    end
  end

  -- print(vim.inspect(results))

  return results
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
