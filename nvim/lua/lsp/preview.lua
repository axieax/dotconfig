-- Preview location --
-- https://github.com/ray-x/navigator.lua/blob/c528b58bb999f20fa609976da9f28b5be5a27414/lua/navigator/definition.lua#L39-L138
-- https://www.reddit.com/r/neovim/comments/jsdox0/builtin_lsp_preview_definition_under_cursor/
-- NOTE: replaced with treesitter text-objects LSP interop

local function callback(_, method, result)
  if not result or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, "No location found")
    return
  end

  local location = require("utils").ternary(vim.tbl_islist(result), result[1], result)
  print(vim.inspect(location))
  local uri = location.uri or location.targetUri
  local range = location.range or location.targetRange
  if not uri or not range then
    return
  end

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local query = "@function.outer"

  -- TODO: determine query based on closest function/class
  --[[ local ts_utils = require("nvim-treesitter.ts_utils")
  local root_lang_tree = require("nvim-treesitter.parsers").get_parser(bufnr)
  if not root_lang_tree then
    return
  end
  local root = ts_utils.get_root_for_position(range.start.line, range.start.character, root_lang_tree)
  if not root then
    return
  end
  local node = root:named_descendant_for_range(
    range.start.line,
    range.start.character,
    range.start.line,
    range.start.character
  )
  print(vim.inspect(node:type())) ]]

  local _, textobject_at_location = require("nvim-treesitter.textobjects.shared").textobject_at_point(
    query,
    { range.start.line + 1, range.start.character },
    bufnr
  )

  local context = textobject_at_location or 0
  require("nvim-treesitter.textobjects.lsp_interop").preview_location(location, context)
end

return function()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(
    0,
    "textDocument/definition",
    params,
    vim.schedule_wrap(
      require("utils").ternary(
        debug.getinfo(vim.lsp.handlers.signature_help).nparams == 4,
        function(err, result, handler_context)
          callback(err, handler_context.method, result)
        end,
        callback
      )
    )
  )
end
