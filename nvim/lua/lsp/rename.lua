-- TODO: Attach handler to rename directly (without this copy and paste)
local M = {}

-----------------------------------------------------------------------------------------------------
-- Set qflist helper function from renamer.nvim (ft my bug fix)                                    --
-- SOURCE: https://github.com/filipdutescu/renamer.nvim/blob/develop/lua/renamer/utils.lua#L48-L79 --
-----------------------------------------------------------------------------------------------------

local function set_qflist(changes)
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

------------------------------------------------------------------------------------------------
-- Initial rename_handler function inspiration from CosmicNvim, notify_handler is original    --
-- SOURCE: https://github.com/CosmicNvim/CosmicNvim/blob/main/lua/cosmic/theme/ui.lua#L51-L84 --
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
  require("lsp.rename").notify_handler(result)

  vim.lsp.handlers[method](...)
end

function M.notify_handler(result)
  if not result then
    return
  end

  -- prefer documentChanges over changes (under workspaceEdit)
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-3-14
  local changes = {}
  if result.documentChanges then
    local msg = ""
    local num_changes = 0
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
    msg = msg:sub(1, #msg - 1)
    require("utils").notify(msg, "info", {
      title = ("Succesfully renamed with %d changes"):format(num_changes),
    })
  elseif result.changes then
    changes = result.changes
    local msg = ""
    local num_changes = 0
    for uri, edits in pairs(changes) do
      local filename = vim.uri_to_fname(uri)
      filename = vim.fn.fnamemodify(filename, ":.")
      msg = msg .. ("%d changes in %s"):format(#edits, filename) .. "\n"
      num_changes = num_changes + #edits
    end
    msg = msg:sub(1, #msg - 1)
    require("utils").notify(msg, "info", {
      title = ("Succesfully renamed with %d changes"):format(num_changes),
    })
  end

  -- set qflist
  set_qflist(changes)
end

--------------------------------------------------------------------------------------
-- LSP rename with helper functions from Neovim source code                         --
-- SOURCE: https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua --
--------------------------------------------------------------------------------------

---@private
--- Returns nil if {status} is false or nil, otherwise returns the rest of the
--- arguments.
local function ok_or_nil(status, ...)
  if not status then
    return
  end
  return ...
end

---@private
--- Swallows errors.
---
---@param fn function to run
---@param ... Function arguments
---@returns Result of `fn(...)` if there are no errors, otherwise nil.
--- Returns nil if errors occur during {fn}, otherwise returns
local function npcall(fn, ...)
  return ok_or_nil(pcall(fn, ...))
end

---@private
--- Sends an async request to all active clients attached to the current
--- buffer.
---
---@param method (string) LSP method name
---@param params (optional, table) Parameters to send to the server
---@param handler (optional, functionnil) See |lsp-handler|. Follows |lsp-handler-resolution|
--
---@returns 2-tuple:
---  - Map of client-id:request-id pairs for all successful requests.
---  - Function which can be used to cancel all the requests. You could instead
---    iterate all clients and call their `cancel_request()` methods.
---
---@see |vim.lsp.buf_request()|
local function request(method, params, handler)
  vim.validate({
    method = { method, "s" },
    handler = { handler, "f", true },
  })
  return vim.lsp.buf_request(0, method, params, handler)
end

---@private
local function make_position_param()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
  if not line then
    return { line = 0, character = 0 }
  end
  -- TODO handle offset_encoding
  local _
  _, col = vim.str_utfindex(line, col)
  return { line = row, character = col }
end

--- Creates a `TextDocumentIdentifier` object for the current buffer.
---
---@returns `TextDocumentIdentifier`
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocumentIdentifier
local function make_text_document_params()
  return { uri = vim.uri_from_bufnr(0) }
end

--- Creates a `TextDocumentPositionParams` object for the current buffer and cursor position.
---
---@returns `TextDocumentPositionParams` object
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocumentPositionParams
local function make_position_params()
  return {
    textDocument = make_text_document_params(),
    position = make_position_param(),
  }
end

--- Renames all references to the symbol under the cursor.
---
---@param new_name (string) If not provided, the user will be prompted for a new
---name using |vim.ui.input()|.
function M.rename(new_name)
  local opts = {
    prompt = "New Name: ",
  }

  ---@private
  local function on_confirm(input)
    if not (input and #input > 0) then
      return
    end
    local params = make_position_params()
    params.newName = input
    request("textDocument/rename", params, M.rename_handler)
  end

  ---@private
  local function prepare_rename(err, result)
    if err == nil and result == nil then
      vim.notify("nothing to rename", vim.log.levels.INFO)
      return
    end
    if result and result.placeholder then
      opts.default = result.placeholder
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    elseif result and result.start and result["end"] and result.start.line == result["end"].line then
      local line = vim.fn.getline(result.start.line + 1)
      local start_char = result.start.character + 1
      local end_char = result["end"].character
      opts.default = string.sub(line, start_char, end_char)
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    else
      -- fallback to guessing symbol using <cword>
      --
      -- this can happen if the language server does not support prepareRename,
      -- returns an unexpected response, or requests for "default behavior"
      --
      -- see https://microsoft.github.io/language-server-protocol/specification#textDocument_prepareRename
      opts.default = vim.fn.expand("<cword>")
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    end
    if new_name then
      on_confirm(new_name)
    end
  end
  request("textDocument/prepareRename", make_position_params(), prepare_rename)
end

return M
