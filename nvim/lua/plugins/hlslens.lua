-- https://github.com/kevinhwang91/nvim-hlslens --
local M = {}

function M.setup()
  require("hlslens").setup({
    -- statusline overlay instead of virtual text
    -- nearest_float_when = "always"
    override_lens = function(render, plist, nearest, idx, r_idx)
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

      local unpack = require("utils").fallback_value(table.unpack, unpack)
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
    end,
  })

  -- other search methods
  local map = require("utils").map
  map({ "n", "*", "*<CMD>lua require'hlslens'.start()<CR>" })
  map({ "n", "g*", "g*<CMD>lua require'hlslens'.start()<CR>" })
  map({ "n", "#", "#<CMD>lua require'hlslens'.start()<CR>" })
  map({ "n", "g#", "g#<CMD>lua require'hlslens'.start()<CR>" })

  -- vim-visual-multi highlights (ctrl-n)
  -- NOTE: does not persist
  vim.cmd([[
  aug VMlens
    au!
    "au User visual_multi_start lua require'plugins.hlslens'.vmlens_start()
    "au User visual_multi_exit lua require'plugins.hlslens'.vmlens_exit()
    au User visual_multi_start lua require'plugins.vmlens'.start()
    au User visual_multi_exit lua require'plugins.vmlens'.exit()
  aug END
  ]])
end

M.override_lens = function(render, plist, nearest, idx, r_idx)
  local _ = r_idx
  local unpack = require("utils").fallback_value(table.unpack, unpack)
  local lnum, col = unpack(plist[idx])

  local text, chunks
  if nearest then
    text = ("[%d/%d]"):format(idx, #plist)
    chunks = { { " ", "Ignore" }, { text, "VM_Extend" } }
  else
    text = ("[%d]"):format(idx)
    chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
  end
  render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
end

local previous_lens

function M.vmlens_start()
  local ok, hlslens = pcall(require, "hlslens")
  if ok then
    local hlslens_config = require("hlslens.config")
    previous_lens = hlslens_config.override_lens
    hlslens_config.override_lens = require("plugins.hlslens").override_lens
    hlslens.start()
  end
end

function M.vmlens_exit()
  local ok, hlslens = pcall(require, "hlslens")
  if ok then
    local hlslens_config = require("hlslens.config")
    hlslens_config.override_lens = previous_lens
    hlslens.start()
  end
end

return M
