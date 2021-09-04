-- https://github.com/godlygeek/tabular --

-- Auto align for markdown cucumber table
-- https://gist.github.com/tpope/287147#gistcomment-3637398
return function()
  if vim.bo.filetype ~= "markdown" then
    return
  end

  local cmd = vim.cmd
  local fn = vim.fn
  local pattern = "^%s*|%s.*%s|%s*$"
  local lineNumber = fn.line(".")
  local currentColumn = fn.col(".")
  local previousLine = fn.getline(lineNumber - 1)
  local currentLine = fn.getline(".")
  local nextLine = fn.getline(lineNumber + 1)

  if
    fn.exists(":Tabularize")
    and currentLine:match("^%s*|")
    and (previousLine:match(pattern) or nextLine:match(pattern))
  then
    local column = #currentLine:sub(1, currentColumn):gsub("[^|]", "")
    local position = #fn.matchstr(currentLine:sub(1, currentColumn), ".*|\\s*\\zs.*")
    cmd("Tabularize/|/l1") -- `l` means left aligned and `1` means one space of cell padding
    cmd("normal! 0")
    fn.search(("[^|]*|"):rep(column) .. ("\\s\\{-\\}"):rep(position), "ce", lineNumber)
  end
end
