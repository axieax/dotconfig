local M = {}

M.setup_colours = function()
  return {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    onedark_cyan = "#56b6c2",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    onedark_orange = "#d19a66",
    highlight = "#e2be7d",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    bg_blue = "#73b8f1",
    onedark_blue = "#61afef",
    red = "#ec5f67",
    fileicon = "#d9a3af",
    filename = "#debac3",
    fileformat = "#dbbade",
    onedark_red = "#e06c75",
    onedark_yellow = "#e5c07b",
    onedark_green = "#98c379",
  }
end

function M.mode()
  return {
    static = {
      mode_names = {
        -- Normal
        n = "Normal",
        no = "Operator Pending",
        -- Insert
        i = "Insert",
        -- Visual
        v = "Visual",
        V = "Visual Line",
        [""] = "Visual Block",
        -- Select
        s = "Select",
        S = "Select Line",
        [""] = "Select Block",
        -- Replace
        R = "Replace",
        Rv = "Virtual Replace",
        -- Exec
        c = "Command",
        cv = "Vim Ex",
        ce = "Normal Ex",
        r = "Hit-Enter Prompt",
        rm = "More Prommpt",
        ["r?"] = "Confirm Query",
        ["!"] = "Shell",
        t = "Terminal",
      },
      mode_colors = {
        n = "violet",
        i = "yellow",
        v = "magenta",
        V = "magenta",
        c = "orange",
        s = "blue",
        S = "blue",
        r = "cyan",
        R = "red",
        ["!"] = "orange",
        t = "green",
      },
    },
    init = function(self)
      self.mode = vim.fn.mode() -- :h mode()

      -- execute this only once, this is required if you want the ViMode
      -- component to be updated on operator pending mode
      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "*:*o",
          command = "redrawstatus",
        })
        self.once = true
      end
    end,
    provider = function(self)
      local name = self.mode_names[self.mode]
      if not name then
        vim.notify("Unknown mode: " .. self.mode, vim.log.levels.ERROR)
        name = "Invalid"
      end
      return " " .. name
    end,
    hl = function(self)
      local mode_char = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode_char] }
    end,
    update = "ModeChanged",
    M.space(),
  }
end

function M.file_name()
  return {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    { -- File Icon
      init = function(self)
        self.icon, _ = require("nvim-web-devicons").get_icon(self.filename)
      end,
      provider = function(self)
        local icon = self.icon
        if not icon and vim.bo.filetype == "TelescopePrompt" then
          icon = ""
        end
        return (icon or "") .. " "
      end,
      hl = { fg = "fileicon" },
      on_click = {
        name = "display_cwd",
        callback = function()
          require("axie.utils").display_cwd()
        end,
      },
      update = { "BufEnter", "BufLeave" },
    },
    { -- File name
      provider = function(self)
        -- local name = vim.fn.fnamemodify(self.filename, ":.")
        -- name = vim.fn.pathshorten(name)
        local name = vim.fn.fnamemodify(self.filename, ":t")
        if name == "" then
          if vim.bo.filetype == "TelescopePrompt" then
            name = "Telescope"
          else
            name = "[No Name]"
          end
        end
        return name .. " "
      end,
      hl = { fg = "filename" },
      on_click = {
        name = "display_path",
        callback = function()
          require("axie.utils").display_path()
        end,
      },
      update = { "BufEnter", "BufLeave" },
    },
    { -- Modified flag
      condition = function()
        return vim.bo.modified
      end,
      provider = "",
      hl = { fg = "yellow" },
      M.space(),
    },
    { -- Read-only flag
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = "",
      hl = { fg = "yellow" },
      M.space(),
    },
    { provider = "%<" }, -- this means that the statusline is cut here when there's not enough space
  }
end

function M.git()
  local conditions = require("heirline.conditions")
  return {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
    end,
    on_click = {
      name = "open_lazygit",
      callback = function()
        vim.defer_fn(function()
          require("axie.plugins.ui.toggleterm").lazygit()
        end, 100)
      end,
    },
    { -- Git Branch
      condition = function(self)
        return self.status_dict.head and self.status_dict.head ~= ""
      end,
      provider = function(self)
        return " " .. self.status_dict.head
      end,
      hl = { fg = "bg_blue" },
      M.space(),
    },
    { -- Git Diff Add
      condition = function(self)
        return self.status_dict.added and self.status_dict.added > 0
      end,
      provider = function(self)
        return " " .. self.status_dict.added
      end,
      hl = { fg = "onedark_green" },
      M.space(),
    },
    { -- Git Diff Modified
      condition = function(self)
        return self.status_dict.changed and self.status_dict.changed > 0
      end,
      provider = function(self)
        return " " .. self.status_dict.changed
      end,
      hl = { fg = "onedark_yellow" },
      M.space(),
    },
    { -- Git Diff Removed
      condition = function(self)
        return self.status_dict.removed and self.status_dict.removed > 0
      end,
      provider = function(self)
        return " " .. self.status_dict.removed
      end,
      hl = { fg = "onedark_red" },
      M.space(),
    },
  }
end

function M.diagnostics()
  local diagnostic_icons = require("axie.utils.config").diagnostics_icons
  local conditions = require("heirline.conditions")

  return {
    condition = conditions.has_diagnostics,
    static = {
      error_icon = diagnostic_icons.Error,
      warn_icon = diagnostic_icons.Warn,
      info_icon = diagnostic_icons.Info,
      hint_icon = diagnostic_icons.Hint,
    },
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { "BufEnter", "BufLeave", "DiagnosticChanged" },
    { -- Error
      condition = function(self)
        return self.errors > 0
      end,
      provider = function(self)
        return self.error_icon .. " " .. self.errors
      end,
      hl = { fg = "onedark_red" },
      M.space(),
    },
    { -- Warn
      condition = function(self)
        return self.warnings > 0
      end,
      provider = function(self)
        return self.warn_icon .. " " .. self.warnings
      end,
      hl = { fg = "onedark_yellow" },
      M.space(),
    },
    { -- Info
      condition = function(self)
        return self.info > 0
      end,
      provider = function(self)
        return self.info_icon .. " " .. self.info
      end,
      hl = { fg = "onedark_blue" },
      M.space(),
    },
    { -- Hint
      condition = function(self)
        return self.hints > 0
      end,
      provider = function(self)
        return self.hint_icon .. " " .. self.hints
      end,
      hl = { fg = "onedark_cyan" },
      M.space(),
    },
  }
end

function M.lsp()
  local conditions = require("heirline.conditions")
  return {
    hl = { fg = "onedark_cyan" },
    { -- Copilot status
      update = { "BufEnter", "BufLeave" },
      init = function(self)
	    local ok, res = pcall(vim.fn, "copilot#Enabled")
		self.copilot_enabled = ok and res ~= 0
      end,
      provider = function(self)
        return self.copilot_enabled and "" or ""
      end,
      on_click = {
        name = "null_ls_info",
        callback = function()
          vim.api.nvim_command("NullLsInfo")
        end,
      },
      M.space(),
    },
    { -- LSP Clients
      static = {
        ignored_servers = { "null-ls", "copilot" },
      },
      condition = conditions.lsp_attached,
      update = { "BufEnter", "BufLeave", "LspAttach", "LspDetach" },
      init = function(self)
        local names = {}
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        local ignored_servers = self.ignored_servers
        for _, client in pairs(clients) do
          if not vim.tbl_contains(ignored_servers, client.name) then
            table.insert(names, client.name)
          end
        end
        self.clients = names
      end,
      provider = function(self)
        local clients = self.clients
        return table.concat(clients, ", ") .. " "
      end,
      on_click = {
        name = "lsp_info",
        callback = function()
          vim.api.nvim_command("LspInfo")
        end,
      },
    },
  }
end

function M.file_format()
  local icons = require("axie.utils.config").fileformat_icons
  return {
    init = function(self)
      self.format = vim.bo.fileformat
    end,
    condition = function(self)
      return self.format ~= nil
    end,
    provider = function(self)
      return icons[self.format] .. " " .. self.format
    end,
    hl = { fg = "fileformat" },
    updates = { "BufEnter", "BufLeave" },
    on_click = {
      name = "convert_format",
      callback = function()
        -- TODO: converts format
      end,
    },
    M.space(),
  }
end

function M.word_count()
  -- TODO
end
function M.line_column()
  -- TODO
end

function M.scrollbar()
  return {
    static = {
      scrollbar = { "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.scrollbar) + 1
      return self.scrollbar[i]
    end,
    hl = { fg = "highlight", bg = "onedark_orange" },
    update = { "BufEnter", "BufLeave", "CursorMoved", "CursorMovedI" },
  }
end

function M.align()
  return { provider = "%=" }
end

function M.space()
  return { provider = " " }
end

function M.bar()
  return { provider = "|" }
end

function M.config()
  local this = require("axie.plugins.ui.statusline")
  local heirline = require("heirline")
  vim.opt.laststatus = 3
  heirline.load_colors(this.setup_colours())

  local augroup = vim.api.nvim_create_augroup("Heirline", {})
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local colours = require("axie.plugins.ui.statusline").setup_colours()
      require("heirline.utils").on_colorscheme(colours)
    end,
    group = augroup,
  })

  -- TODO: dap controls (in a winbar??)
  local statusline = {
    this.scrollbar(),
    this.space(),
    this.mode(),
    this.file_name(),
    this.git(),

    -- this.bar(),
    this.align(),
    -- this.bar(),
    this.space(),
    this.diagnostics(),
    -- this.bar(),
    this.align(),
    -- this.bar(),

    this.space(),
    this.lsp(),
    this.file_format(),
    -- this.word_count(),
    -- this.line_column(),
    this.scrollbar(),
  }

  heirline.setup(statusline)
end

return M
