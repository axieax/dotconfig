-- TODO: range code action for visual selection

local function code_action_handler(results, ctx, ignore_null_ls)
  local action_tuples = {}
  local null_action_tuples = {}
  for client_id, result in pairs(results) do
    local client = vim.lsp.get_client_by_id(client_id)
    local is_null = client.name == "null-ls"

    if not is_null or (is_null and not ignore_null_ls) then
      for _, action in pairs(result.result or {}) do
        local action_tuple = { client_id, action }
        if is_null then
          table.insert(null_action_tuples, action_tuple)
        else
          table.insert(action_tuples, action_tuple)
        end
      end
    end
  end

  -- Force null-ls actions to be at the end of normal actions
  vim.list_extend(action_tuples, null_action_tuples)

  if #action_tuples == 0 then
    vim.api.nvim_echo({ { " No code actions available", "WarningMsg" } }, false, {})
    return
  end

  -- SOURCE: the rest of this function is taken from https://github.com/mjlbach/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L506-L567

  ---@private
  local function apply_action(action, client)
    if action.edit then
      vim.lsp.buf.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    if action.command then
      local command = type(action.command) == "table" and action.command or action
      local fn = client.commands[command.command] or vim.lsp.commands[command.command]
      if fn then
        local enriched_ctx = vim.deepcopy(ctx)
        enriched_ctx.client_id = client.id
        fn(command, enriched_ctx)
      else
        M.execute_command(command)
      end
    end
  end

  ---@private
  local function on_user_choice(action_tuple)
    if not action_tuple then
      return
    end
    -- textDocument/codeAction can return either Command[] or CodeAction[]
    --
    -- CodeAction
    --  ...
    --  edit?: WorkspaceEdit    -- <- must be applied before command
    --  command?: Command
    --
    -- Command:
    --  title: string
    --  command: string
    --  arguments?: any[]
    --
    local client = vim.lsp.get_client_by_id(action_tuple[1])
    local action = action_tuple[2]
    if
      not action.edit
      and client
      and type(client.resolved_capabilities.code_action) == "table"
      and client.resolved_capabilities.code_action.resolveProvider
    then
      client.request("codeAction/resolve", action, function(err, resolved_action)
        if err then
          vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
          return
        end
        apply_action(resolved_action, client)
      end)
    else
      apply_action(action, client)
    end
  end

  vim.ui.select(action_tuples, {
    prompt = "Code actions:",
    kind = "codeaction",
    format_item = function(action_tuple)
      local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
      return title:gsub("\n", "\\n")
    end,
  }, on_user_choice)
end

return function(ignore_null_ls, context)
  ignore_null_ls = ignore_null_ls or false

  -- Override request function
  local original_requester = vim.lsp.buf_request_all
  vim.lsp.buf_request_all = function(bufnr, method, params, _)
    original_requester(bufnr, method, params, function(results)
      local ctx = {
        bufnr = bufnr,
        method = method,
        params = params,
      }
      code_action_handler(results, ctx, ignore_null_ls)
    end)
  end

  vim.lsp.buf.code_action(context)
  vim.lsp.buf_request_all = original_requester
end
