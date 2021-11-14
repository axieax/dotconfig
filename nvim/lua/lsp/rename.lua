-- TODO: hover window: https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
-- https://www.reddit.com/r/neovim/comments/qpns4g/renamernvim_vs_codelike_renaming_ui_for_neovim/

-- LSP rename with notify handler --
local notify = require("notify")

local function popup(curr_name)
  curr_name = "test"
  local tshl = require("nvim-treesitter-playground.hl-info").get_treesitter_hl()
  if tshl and #tshl > 0 then
    local ind = tshl[#tshl]:match("^.*()%*%*.*%*%*")
    tshl = tshl[#tshl]:sub(ind + 2, -3)
  end

  local win = require("plenary.popup").create(curr_name, {
    title = "New Name",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "FloatBorder",
    titlehighlight = "Title",
    highlight = tshl,
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  local map_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, "i", "<ESC>", "<CMD>stopinsert | q!<CR>", map_opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<ESC>", "<CMD>stopinsert | q!<CR>", map_opts)
end

-- popup()

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

  -- prefer documentChanges over changes (under workspaceEdit)
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-3-14
  -- TODO: send to qflist?
  -- https://youtu.be/tAVxxdFFYMU
  if result and result.documentChanges then
    local msg = ""
    local num_changes = 0
    for _, entry in ipairs(result.documentChanges) do
      local edits = entry.edits
      local filename = vim.uri_to_fname(entry.textDocument.uri)
      msg = msg .. ("%d changes in %s"):format(#edits, filename) .. "\n"
      num_changes = num_changes + #edits
    end
    msg = msg:sub(1, #msg - 1)
    notify(msg, "info", {
      title = ("Succesfully renamed with %d changes"):format(num_changes),
    })
  elseif result and result.changes then
    local msg = ""
    local num_changes = 0
    for uri, edits in pairs(result.changes) do
      local filename = vim.uri_to_fname(uri)
      msg = msg .. ("%d changes in %s"):format(#edits, filename) .. "\n"
      num_changes = num_changes + #edits
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
local function rename(new_name)
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
