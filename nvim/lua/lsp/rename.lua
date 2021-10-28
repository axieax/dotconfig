-- TODO: lspsaga prompt rename -> handler for notifying changes

-- LSP rename with notify handler --
local notify = require("notify")

-- handler from https://github.com/mattleong/CosmicNvim/blob/main/lua/cosmic/core/theme/ui.lua#L47-L94
local function handler(...)
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
  -- echo the resulting changes
  if result and result.changes then
    local num_changes = 0
    local new_name = ""
    local msg = ""
    for f, c in pairs(result.changes) do
      f = vim.fn.fnamemodify(vim.fn.expand(f), ":~:.")
      msg = msg .. ("%d changes -> %s"):format(#c, f) .. "\n"
      num_changes = num_changes + #c
      new_name = c.newText
    end
    msg = msg:sub(1, #msg - 1)
    notify(msg, "info", {
      title = ("Succesfully renamed with %d changes"):format(num_changes),
    })
  end
  vim.lsp.handlers[method](...)
end

-- from https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L247-L280

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
---@param fn Function to run
---@param ... Function arguments
---@returns Result of `fn(...)` if there are no errors, otherwise nil.
--- Returns nil if errors occur during {fn}, otherwise returns
local function npcall(fn, ...)
  return ok_or_nil(pcall(fn, ...))
end

--- Renames all references to the symbol under the cursor.
---
---@param new_name (string) If not provided, the user will be prompted for a new
---name using |input()|.
function rename(new_name)
  local params = vim.lsp.util.make_position_params()
  local function prepare_rename(err, result)
    if err == nil and result == nil then
      notify("nothing to rename", vim.log.levels.INFO)
      return
    end
    if result and result.placeholder then
      new_name = new_name or npcall(vim.fn.input, "New Name: ", result.placeholder)
    elseif result and result.start and result["end"] and result.start.line == result["end"].line then
      local line = vim.fn.getline(result.start.line + 1)
      local start_char = result.start.character + 1
      local end_char = result["end"].character
      new_name = new_name or npcall(vim.fn.input, "New Name: ", string.sub(line, start_char, end_char))
    else
      -- fallback to guessing symbol using <cword>
      --
      -- this can happen if the language server does not support prepareRename,
      -- returns an unexpected response, or requests for "default behavior"
      --
      -- see https://microsoft.github.io/language-server-protocol/specification#textDocument_prepareRename
      new_name = new_name or npcall(vim.fn.input, "New Name: ", vim.fn.expand("<cword>"))
    end
    if not (new_name and #new_name > 0) then
      return
    end
    params.newName = new_name
    vim.lsp.buf_request(0, "textDocument/rename", params, handler) -- include handler
  end
  vim.lsp.buf_request(0, "textDocument/prepareRename", params, prepare_rename)
end

return rename
