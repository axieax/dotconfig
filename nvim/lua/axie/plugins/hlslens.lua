local M = {}

function M.override_lens(render, plist, nearest, idx, r_idx)
  local sfw = vim.v.searchforward == 1
  local indicator, text, chunks
  local abs_r_idx = math.abs(r_idx)
  if abs_r_idx >= 1 then
    indicator = ("%d%s"):format(abs_r_idx, sfw ~= (r_idx > 1) and "▲" or "▼")
    -- elseif abs_r_idx == 1 then
    --   indicator = sfw ~= (r_idx == 1) and "▲" or "▼"
  else
    indicator = ""
  end

  local lnum, col = unpack(plist[idx])
  if nearest then
    local cnt = #plist
    if indicator ~= "" then
      text = ("[%s%d/%d]"):format(indicator, idx, cnt)
    else
      text = ("[%d/%d]"):format(idx, cnt)
    end
    chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
  else
    text = ("[%s%d]"):format(indicator, idx)
    chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
  end
  render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
end

function M.config()
  local this = require("axie.plugins.hlslens")
  require("hlslens").setup({
    -- statusline overlay instead of virtual text
    -- nearest_float_when = "always",
    override_lens = this.override_lens,
  })

  -- clear highlighting on double escape
  vim.keymap.set("n", "<Esc><Esc>", [[:let @/=""<CR>]], { silent = true })

  -- other search methods
  for _, trigger in ipairs({ "n", "N" }) do
    vim.keymap.set(
      "n",
      trigger,
      string.format("<Cmd>execute('normal! ' . v:count1 . '%s')<CR><Cmd>lua require('hlslens').start()<CR>", trigger)
    )
  end

  for _, trigger in ipairs({ "*", "g*", "#", "g#" }) do
    vim.keymap.set("n", trigger, trigger .. "<Cmd>lua require'hlslens'.start()<CR>")
  end

  -- vim-visual-multi highlights (ctrl-n)
  -- BUG: lens disappear with navigation
  local vmlens = vim.api.nvim_create_augroup("VMLens", {})
  vim.api.nvim_create_autocmd("User", {
    pattern = "visual_multi_start",
    group = vmlens,
    callback = this.vmlens_start,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "visual_multi_exit",
    group = vmlens,
    callback = this.vmlens_exit,
  })
end

local hlslens_config
local previous_lens

function M.vmlens_start()
  local ok, hlslens = pcall(require, "hlslens")
  if ok then
    hlslens_config = require("hlslens.config")
    previous_lens = hlslens_config.override_lens
    hlslens_config.override_lens = require("axie.plugins.hlslens").override_lens
    hlslens.start(true)
  end
end

function M.vmlens_exit()
  local ok, hlslens = pcall(require, "hlslens")
  if ok then
    hlslens_config.override_lens = previous_lens
    hlslens.start(true)
  end
end

return M
