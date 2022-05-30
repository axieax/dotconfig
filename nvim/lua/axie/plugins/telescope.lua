local M = {}

local hidden_patterns = {
  "%.git/",
  "node_modules/",
}

function M.file_search(no_ignore)
  -- Vim rooter sets Git project scope anyways
  no_ignore = no_ignore or false
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = no_ignore,
    file_ignore_patterns = hidden_patterns,
  })
end

function M.dotconfig()
  require("telescope.builtin").find_files({
    prompt_title = "dotconfig",
    search_dirs = { "~/dotconfig" },
    hidden = true,
    file_ignore_patterns = hidden_patterns,
  })
end

function M.binds()
  local this = require("axie.plugins.telescope")
  local builtin = require("telescope.builtin")
  local require_args = require("axie.utils").require_args

  vim.keymap.set("n", "<C-_>", builtin.current_buffer_fuzzy_find, { desc = "buffer search" }) -- control slash
  vim.keymap.set("n", "<Space>fh", builtin.help_tags, { desc = "help docs" })
  vim.keymap.set("n", "<Space>fo", builtin.oldfiles, { desc = "old files" }) -- TODO: MRU
  vim.keymap.set("n", "<Space>ff", this.file_search, { desc = "find files" })
  vim.keymap.set("n", "<Space>fF", require_args(this.file_search, true), { desc = "find all files" })
  vim.keymap.set("n", "<Space>fc", this.dotconfig, { desc = "search config" })
  vim.keymap.set("n", "<Space>fg", builtin.live_grep, { desc = "live grep" })
  vim.keymap.set("n", "<Space>fG", builtin.grep_string, { desc = "grep string" })
  vim.keymap.set("n", "<Space>fm", builtin.man_pages, { desc = "search manual" })
  vim.keymap.set("n", "<Space>ft", builtin.colorscheme, { desc = "theme" })
  vim.keymap.set(
    "n",
    "<Space>fT",
    require_args(builtin.colorscheme, { enable_preview = true }),
    { desc = "theme preview" }
  )
  vim.keymap.set("n", "<Space>f.", builtin.resume, { desc = "resume last command" })
  vim.keymap.set("n", "<Space>fk", builtin.keymaps, { desc = "find keymaps" })
end

function M.setup()
  -- telescope setup mappings table - inside telescope overlay
  -- TODO: overwrite dotfiles? action for opening current file in native file explorer?
  local ternary = require("axie.utils").ternary

  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      winblend = ternary(require("axie.utils.config").nvchad_theme, 10, 0),
      sorting_strategy = "ascending",
      -- layout_strategy = ternary(vim.o.lines > 41, "vertical", "horizontal"),
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.7,
        },
        vertical = {
          prompt_position = "top",
          mirror = true,
        },
        center = {
          -- width = 0.6,
          width = function(_, max_columns)
            -- set max width
            local percentage = 0.6
            local max = 120
            return math.min(math.floor(max_columns * percentage), max)
          end,
        },
      },
      -- NOTE: https://github.com/nvim-telescope/telescope.nvim/issues/1080
      tiebreak = function(_, _)
        return false
      end,
    },
    extensions = {
      media_files = {
        -- pip install ueberzug for images
        -- pdftoppm for pdf
        -- ffmpegthumbnailer for videos
        filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
        find_cmd = "rg",
      },
    },
  })

  telescope.load_extension("fzf")
  require("axie.plugins.telescope").binds()
end

return M
