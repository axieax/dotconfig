-- TODO: Attach handler to rename directly (without this copy and paste)
local M = {}

---Calls vim.lsp.buf.rename without the default text
function M.rename_empty()
  -- Override vim.ui.input function to remove default text
  local original_ui_input = vim.ui.input
  vim.ui.input = function(opts, on_confirm)
    opts.default = ""
    original_ui_input(opts, on_confirm)
    vim.ui.input = original_ui_input
  end

  vim.lsp.buf.rename()
end

------------------------------------------------------------------------------------------------
-- Initial rename_handler function inspiration from CosmicNvim/cosmic-ui                      --
-- SOURCE: https://github.com/CosmicNvim/cosmic-ui/blob/main/lua/cosmic-ui/rename/handler.lua --
------------------------------------------------------------------------------------------------

function M.rename_handler(...)
  local result
  local method
  local err = select(1, ...)
  local is_new = not select(4, ...) or type(select(4, ...)) ~= "number"
  if is_new then
    method = select(3, ...).method
    result = select(2, ...)
  else
    method = select(2, ...)
    result = select(3, ...)
  end

  if err then
    vim.notify(("Error running LSP query '%s': %s"):format(method, err), vim.log.levels.ERROR)
    return
  end

  -- display the resulting changes
  require("axie.lsp.rename").notify_handler(result)

  vim.lsp.handlers[method](...)
end

----------------------------------------
-- Notifies successful rename changes --
----------------------------------------

function M.notify_handler(result)
  if not result then
    return
  end

  local notify = require("axie.utils").notify
  local msg = ""
  local num_changes = 0

  -- prefer documentChanges over changes (under workspaceEdit)
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-3-14
  local changes = {}
  if result.documentChanges then
    for _, entry in ipairs(result.documentChanges) do
      local edits = entry.edits
      if edits then
        local filename = vim.uri_to_fname(entry.textDocument.uri)
        filename = vim.fn.fnamemodify(filename, ":.")
        msg = msg .. ("%d changes in %s"):format(#edits, filename) .. "\n"
        num_changes = num_changes + #edits
      end
      changes[entry.textDocument.uri] = edits
    end
  elseif result.changes then
    changes = result.changes
    for uri, edits in pairs(changes) do
      local filename = vim.uri_to_fname(uri)
      filename = vim.fn.fnamemodify(filename, ":.")
      msg = msg .. ("%d changes in %s"):format(#edits, filename) .. "\n"
      num_changes = num_changes + #edits
    end
  end
  msg = msg:sub(1, #msg - 1)
  notify(msg, "info", {
    title = ("Succesfully renamed with %d changes"):format(num_changes),
  })

  -- set qflist
  M.set_qflist(changes)
end

-----------------------------------------------------------------------------------------------------
-- Set qflist helper function from renamer.nvim (ft my bug fix)                                    --
-- SOURCE: https://github.com/filipdutescu/renamer.nvim/blob/develop/lua/renamer/utils.lua#L48-L79 --
-----------------------------------------------------------------------------------------------------

function M.set_qflist(changes)
  if changes then
    local qf_list, i = {}, 0
    for file, data in pairs(changes) do
      local buf_id = -1
      if vim.uri and vim.uri.uri_to_bufnr then
        buf_id = vim.uri.uri_to_bufnr(file)
      else
        local file_path = string.gsub(file, "file://", "")
        buf_id = vim.fn.bufadd(file_path)
      end
      vim.fn.bufload(buf_id)
      file = string.gsub(file, "file://", "")

      for _, change in ipairs(data) do
        local row, col = change.range.start.line, change.range.start.character
        i = i + 1
        local line = vim.api.nvim_buf_get_lines(buf_id, row, row + 1, false)
        qf_list[i] = {
          text = line and line[1],
          filename = file,
          lnum = row + 1,
          col = col + 1,
        }
      end
    end

    if qf_list and i > 0 then
      vim.fn.setqflist(qf_list)
    end
  end
end

return M
