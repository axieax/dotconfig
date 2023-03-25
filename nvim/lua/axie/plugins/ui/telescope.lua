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
  {
    "<C-_>", -- control slash
    function()
      require("telescope.builtin").current_buffer_fuzzy_find()
    end,
    desc = "Buffer search",
  },
  {
    "<Space>f/",
    function()
      require("telescope.builtin").current_buffer_fuzzy_find()
    end,
    desc = "Buffer search",
  },
  -- TODO: MRU
  {
    "<Space>fo",
    function()
      require("telescope.builtin").oldfiles()
    end,
    desc = "Recent files",
  },
  {
    "<Space>ff",
    function()
      require("axie.plugins.ui.telescope").file_search()
    end,
    desc = "Find files",
  },
  {
    "<Space>fF",
    function()
      require("axie.plugins.ui.telescope").file_search(true)
    end,
    desc = "Find all files",
  },
  {
    "<Space>fc",
    function()
      require("axie.plugins.ui.telescope").dotconfig()
    end,
    desc = "Search config",
  },
  {
    "<Space>fg",
    function()
      require("telescope.builtin").live_grep()
    end,
    desc = "Live grep",
  },
  {
    "<Space>fG",
    function()
      require("telescope.builtin").grep_string()
    end,
    desc = "Grep string",
  },
  {
    "<Space>fb",
    function()
      require("telescope.builtin").buffers()
    end,
    desc = "Open buffers",
  },
  {
    '<Space>f"',
    function()
      require("telescope.builtin").registers()
    end,
    desc = "Registers",
  },
  {
    "<Space>fh",
    function()
      require("telescope.builtin").help_tags()
    end,
    desc = "Help docs",
  },
  {
    "<Space>fm",
    function()
      -- REF: https://en.wikipedia.org/wiki/Man_page#Manual_sections
      require("telescope.builtin").man_pages({ sections = { "1", "2", "3", "4", "5", "6", "7", "8" } })
    end,
    desc = "Search manual",
  },
  {
    "<Space>fv",
    function()
      require("telescope.builtin").vim_options()
    end,
    desc = "Vim options",
  },
  {
    "<Space>ft",
    function()
      require("telescope.builtin").colorscheme()
    end,
    desc = "Theme",
  },
  {
    "<Space>fT",
    function()
      require("telescope.builtin").colorscheme({ enable_preview = true })
    end,
    desc = "Theme preview",
  },
  {
    "<Space>fH",
    function()
      require("telescope.builtin").highlights()
    end,
    desc = "Highlight groups",
  },
  {
    "<Space>f.",
    function()
      require("telescope.builtin").resume()
    end,
    desc = "Resume last command",
  },
  {
    "<Space>f?",
    function()
      require("telescope.builtin").commands()
    end,
    desc = "Find commands",
  },
  {
    "<Space>fk",
    function()
      require("telescope.builtin").keymaps()
    end,
    desc = "Find keymaps",
  },
  {
    "<Space>gc",
    function()
      require("telescope.builtin").git_bcommits()
    end,
    desc = "Buffer Git commits",
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
      file_browser = {
        -- prompt_path = true,
        mappings = {
          i = {
            ["<C-y>"] = function(prompt_bufnr)
              local symbol = require("telescope.actions.state").get_selected_entry().ordinal
              vim.fn.setreg('"', symbol)
              actions.close(prompt_bufnr)
            end,
            ["<C-p>"] = function(prompt_bufnr)
              local symbol = require("telescope.actions.state").get_selected_entry().value
              vim.fn.setreg('"', symbol)
              actions.close(prompt_bufnr)
            end,
          },
        },
      },
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
end

function M.init()
  local loaded = false
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    -- BUG: closing a window also triggers `CmdlineEnter`
    pattern = ":",
    group = vim.api.nvim_create_augroup("TelescopeExtensions", {}),
    callback = vim.schedule_wrap(function()
      if not loaded then
        local telescope = require("telescope")
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
        telescope.load_extension("zoxide")
        telescope.load_extension("neoclip")
        telescope.load_extension("macroscope")

        loaded = true
      end
    end),
  })
end

return M
