local M = {}

M.cmd = "Telescope"

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

M.keys = {
  -- control slash
  {
    "<C-_>",
    function()
      require("telescope.builtin").current_buffer_fuzzy_find()
    end,
    desc = "buffer search",
  },
  {
    "<Space>fh",
    function()
      require("telescope.builtin").help_tags()
    end,
    desc = "help docs",
  },
  -- TODO: MRU
  {
    "<Space>fo",
    function()
      require("telescope.builtin").oldfiles()
    end,
    desc = "old files",
  },
  {
    "<Space>ff",
    function()
      require("axie.plugins.ui.telescope").file_search()
    end,
    desc = "find files",
  },
  {
    "<Space>fF",
    function()
      require("axie.plugins.ui.telescope").file_search(true)
    end,
    desc = "find all files",
  },
  {
    "<Space>fc",
    function()
      require("axie.plugins.ui.telescope").dotconfig()
    end,
    desc = "search config",
  },
  {
    "<Space>fg",
    function()
      require("telescope.builtin").live_grep()
    end,
    desc = "live grep",
  },
  {
    "<Space>fG",
    function()
      require("telescope.builtin").grep_string()
    end,
    desc = "grep string",
  },
  {
    "<Space>fm",
    function()
      -- REF: https://en.wikipedia.org/wiki/Man_page#Manual_sections
      require("telescope.builtin").man_pages({ sections = { "1", "2", "3", "4", "5", "6", "7", "8" } })
    end,
    desc = "search manual",
  },
  {
    "<Space>ft",
    function()
      require("telescope.builtin").colorscheme()
    end,
    desc = "theme",
  },
  {
    "<Space>fT",
    function()
      require("telescope.builtin").colorscheme({ enable_preview = true })
    end,
    desc = "theme preview",
  },
  {
    "<Space>f.",
    function()
      require("telescope.builtin").resume()
    end,
    desc = "resume last command",
  },
  {
    "<Space>fk",
    function()
      require("telescope.builtin").keymaps()
    end,
    desc = "find keymaps",
  },
}

function M.config()
  -- telescope setup mappings table - inside telescope overlay
  -- TODO: overwrite dotfiles? action for opening current file in native file explorer?
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      winblend = require("axie.utils.config").nvchad_theme and 10 or 0,
      sorting_strategy = "ascending",
      -- layout_strategy = vim.o.lines > 41 and "vertical" or "horizontal",
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
      mappings = {
        i = {
          ["C-k"] = actions.move_selection_previous,
          ["C-j"] = actions.move_selection_next,
        },
      },
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
  telescope.load_extension("file_browser")
  if require("axie.utils").get_os() == "linux" then
    telescope.load_extension("media_files")
  end
  telescope.load_extension("env")
  telescope.load_extension("node_modules")
  telescope.load_extension("dap")
  telescope.load_extension("termfinder")
  telescope.load_extension("aerial")
  telescope.load_extension("projects")
  telescope.load_extension("notify")
end

return M
