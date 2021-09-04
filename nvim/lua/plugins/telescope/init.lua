-- https://github.com/nvim-telescope/telescope.nvim --
-- https://github.com/whatsthatsmell/dots/blob/master/public%20dots/vim-nvim/lua/joel/telescope/init.lua

--[[TODO
-- fzf native https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- image preview https://github.com/nvim-telescope/telescope-media-files.nvim
-- recent https://github.com/nvim-telescope/telescope-frecency.nvim
-- lsp maps
-- move top prompt above results, and all results ascending
--]]

return function()
  local map = require("utils").map
  map({ "n", "<Space>ff", "<cmd>lua require('plugins.telescope.helpers').file_search(false)<cr>" })
  map({ "n", "<Space>fc", "<cmd>lua require('plugins.telescope.helpers').dotconfig()<cr>" })
  map({ "n", "<Space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>" })
  map({ "n", "<Space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>" })
  map({ "n", "<Space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>" })
  map({ "n", "<Space>fe", "<cmd>lua require('plugins.telescope.helpers').explorer()<cr>" })
  vim.cmd("autocmd VimEnter * lua require('plugins.telescope.helpers').file_search(true)")
  map({ "n", "<Space>fH", "<cmd>lua require('telescope.builtin').vim_options()<cr>" })
  map({ "n", "<C-_>", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" }) -- control slash NOTE: inverse order
  map({ "n", "<Space>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>" })
  map({ "n", "<Space>fr", "<cmd>lua require('telescope.builtin').registers()<cr>" })
  map({ "n", "<Space>ft", "<cmd>lua require('telescope.builtin').colorscheme()<cr>" })
  map({ "n", "<Space>fm", "<cmd>lua require('telescope.builtin').man_pages()<cr>" })
  map({ "n", "<Space>fs", "<cmd>lua require('telescope.builtin').spell_suggest()<cr>" })
  map({ "n", "<Space>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>" })
  map({ "n", "<Space>f/", "<cmd>lua require('telescope.builtin').search_history()<cr>" })
  map({ "n", "<Space>f;", "<cmd>lua require('telescope.builtin').command_history()<cr>" })

  map({ "n", "<Space>gs", "<cmd>lua require('telescope.builtin').git_stash()<cr>" })
  map({ "n", "<Space>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>" })
  map({ "n", "<Space>g?", "<cmd>lua require('telescope.builtin').git_status()<cr>" })
  map({ "n", "<Space>gc", "<cmd>lua require('telescope.builtin').git_bcommits()<cr>" })
  map({ "n", "<Space>gC", "<cmd>lua require('telescope.builtin').git_commits()<cr>" })

  -- telescope setup mappings table - inside telescope overlay
  -- TODO: overwrite dotfiles? action for opening current file in native file explorer?
  require("telescope").setup({
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.7,
        },
        vertical = {
          prompt_position = "top",
        },
      },
    },
  })

  -- Extensions
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("dap")

  -- Can Telescope file browser create/move/delete files?
end
