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

function M.setup()
  -- telescope setup mappings table - inside telescope overlay
  -- TODO: overwrite dotfiles? action for opening current file in native file explorer?
  local ternary = require("axie.utils").ternary

  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      winblend = ternary(require("axie.utils.config").nvchad_theme, 10, 0),
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
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
        layout_strategy = "center",
        layout_config = {
          bottom_pane = { height = 10 },
        },
      },
    },
  })

  -- TEMP: zoxide override mappings
  require("telescope._extensions.zoxide.config").setup({
    mappings = {
      ["<C-b>"] = {
        keepinsert = true,
        action = function(selection)
          pcall(function(path)
            telescope.extensions.file_browser.file_browser({
              cwd = path,
            })
          end, selection.path)
        end,
      },
    },
  })

  -- Extensions
  telescope.load_extension("fzf")
  telescope.load_extension("media_files")
  telescope.load_extension("file_browser")
  telescope.load_extension("env")
  telescope.load_extension("zoxide")
  telescope.load_extension("node_modules")

  pcall(telescope.load_extension, "urlview")
end

return M
