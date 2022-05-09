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
  local require_args = require("axie.utils").require_args

  -- General
  vim.keymap.set("n", "<Space>?", "<Cmd>Telescope keymaps<CR>", { desc = "keymaps" })
  vim.keymap.set("n", "<Space>fk", "<Cmd>Telescope keymaps<CR>", { desc = "find keymaps" })
  vim.keymap.set("n", "<Space>f?", "<Cmd>Telescope commands<CR>", { desc = "commands" })
  vim.keymap.set("n", "<Space>f/", "<Cmd>Telescope search_history<CR>", { desc = "search history" })
  vim.keymap.set("n", "<Space>f;", "<Cmd>Telescope command_history<CR>", { desc = "command history" })
  vim.keymap.set("n", "<Space>ft", "<Cmd>Telescope colorscheme<CR>", { desc = "theme" })
  vim.keymap.set("n", "<Space>fT", "<Cmd>Telescope colorscheme enable_preview=true", { desc = "theme preview" })
  vim.keymap.set("n", "<Space>fs", "1z=", { desc = "spelling correct" })
  vim.keymap.set("n", "<Space>fS", "<Cmd>Telescope spell_suggest<CR>", { desc = "spelling suggestions" })
  vim.keymap.set("n", "<Space>f.", "<Cmd>Telescope resume<CR>", { desc = "resume last command" })

  -- Search
  vim.keymap.set("n", "<C-_>", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "buffer search" }) -- control slash
  vim.keymap.set("n", "<Space>fo", "<Cmd>Telescope old_files<CR>", { desc = "old files" }) -- TODO: MRU
  vim.keymap.set("n", "<Space>ff", this.file_search, { desc = "find files" })
  vim.keymap.set("n", "<Space>fF", require_args(this.file_search, true), { desc = "find all files" })
  vim.keymap.set("n", "<Space>fc", this.dotconfig, { desc = "search config" })
  vim.keymap.set("n", "<Space>fg", "<Cmd>Telescope live_grep<CR>", { desc = "live grep" })
  vim.keymap.set("n", "<Space>fG", "<Cmd>Telescope grep_string<CR>", { desc = "grep string" })
  vim.keymap.set("n", "<Space>fh", "<Cmd>Telescope help_tags<CR>", { desc = "help docs" })
  vim.keymap.set("n", "<Space>fH", "<Cmd>Telescope vim_options<CR>", { desc = "vim options" })
  vim.keymap.set("n", "<Space>fm", "<Cmd>Telescope man_pages<CR>", { desc = "search manual" })
  vim.keymap.set("n", "<Space>fb", "<Cmd>Telescope buffers<CR>", { desc = "find buffers" })
  vim.keymap.set("n", "<Space>fa", "<Cmd>Telescope symbols<CR>", { desc = "find symbols" })
  vim.keymap.set("n", "<Space>fr", "<Cmd>Telescope registers<CR>", { desc = "registers" }) -- could be "
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
      tiebreak = function(current_entry, existing_entry)
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
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({ layout_strategy = "center" }),
      },
    },
  })

  telescope.load_extension("fzf")
end

return M
