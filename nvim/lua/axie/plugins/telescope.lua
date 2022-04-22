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
  local telescope = require("telescope")
  telescope.setup({
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
    extensions = {
      media_files = {
        -- pip install ueberzug for images
        -- pdftoppm for pdf
        -- ffmpegthumbnailer for videos
        filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
        find_cmd = "rg",
      },
      -- ["ui-select"] = {
      --   require("telescope.themes").get_dropdown(),
      -- },
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
  telescope.load_extension("dap")
  telescope.load_extension("media_files")
  telescope.load_extension("file_browser")
  telescope.load_extension("env")
  telescope.load_extension("zoxide")
  telescope.load_extension("notify")
  telescope.load_extension("aerial")
  telescope.load_extension("termfinder")
  -- telescope.load_extension("node_modules")
  -- telescope.load_extension("ui-select")

  pcall(telescope.load_extension, "urlview")
end

return M
