-- TODO: use CodeActionMenu or Telescope

local no_code_actions_notify = function()
  vim.api.nvim_echo({ { " No code actions available", "WarningMsg" } }, false, {})
end

return function(ignore_null_ls, context)
  ignore_null_ls = ignore_null_ls or false

  -- Override vim.notify
  local original_notify = vim.notify
  vim.notify = no_code_actions_notify

  -- Override vim.ui.select
  local original_ui_select = vim.ui.select
  vim.ui.select = function(items, opts, on_choice)
    -- Sort items to ensure null-ls actions are at the end
    local action_tuples = {}
    local null_action_tuples = {}
    for _, item in ipairs(items) do
      local client = vim.lsp.get_client_by_id(item[1])
      local is_null = client.name == "null-ls"

      -- Filter if null-ls actions if requested
      if not is_null or (is_null and not ignore_null_ls) then
        if is_null then
          table.insert(null_action_tuples, item)
        else
          table.insert(action_tuples, item)
        end
      end
    end
    vim.list_extend(action_tuples, null_action_tuples)

    if #action_tuples == 0 then
      no_code_actions_notify()
    else
      original_ui_select(action_tuples, opts, on_choice)
    end

    -- Restore functions
    vim.ui.select = original_ui_select
    vim.notify = original_notify
  end

  vim.lsp.buf.code_action(context)
end
