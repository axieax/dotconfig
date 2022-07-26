-- https://github.com/williamboman/nvim-lsp-installer --

local M = {}

M.ensure_installed = {
  ---------------
  -- Scripting --
  ---------------
  "pyright",
  "lua-language-server",
  "bash-language-server",
  ---------------------
  -- Web Development --
  ---------------------
  -- "dockerfile-language-server",
  "typescript-language-server",
  "emmet-ls",
  "json-lsp",
  -- "eslint_d",
  -- "css-lsp",
  -- "html-lsp",
  -------------------
  -- Miscellaneous --
  -------------------
  -- "jdtls",
  "clangd",
  "ltex-ls",
  -- "cmake-language-server",
  -- "rust-analyzer",
  -- "gopls",
  -- "haskell-language-server",
  -- "sqls",
  -- "texlab",
}

--- Setup a language server with lspconfig
---@param name string @The name of the language server
---@param opts table @Optional table of options to pass to the language server
function M.setup_lspconfig(name, opts)
  opts = opts or require("axie.lsp.options").get(name)
  require("lspconfig")[name].setup(opts)
end

--- Setup a language server using the `cb` function provided
---@param name string @The name of the language server
---@param cb function @Setup function for the language server
---@param key string @Optional key in dictionary passed to the setup function containing custom options
function M.setup_custom(name, cb, key)
  local opts = require("axie.lsp.options").get(name)
  local pattern = opts.filetypes
  if not pattern then
    pattern = require("lspconfig.server_configurations." .. name).default_config.filetypes
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = pattern,
    callback = function()
      opts.autostart = true
      if key then
        cb({ [key] = opts })
      else
        cb(opts)
      end
    end,
  })
end

--- Setup language servers
function M.servers()
  -- Setup installed language servers
  local this = require("axie.lsp.setup")
  local installed_servers = require("mason-lspconfig").get_installed_servers()
  for _, server in ipairs(installed_servers) do
    this.setup_lspconfig(server)
  end

  -- Setup language servers via autocmd
  this.setup_custom("jdtls", require("jdtls").start_or_attach)
  this.setup_custom("rust_analyzer", require("rust-tools").setup, "server")
  this.setup_custom("clangd", require("clangd_extensions").setup, "server")
  this.setup_custom("grammarly", function(opts)
    vim.keymap.set("n", "\\g", function()
      -- Stop Grammarly client if active
      local clients = vim.lsp.buf_get_clients()
      for _, client in pairs(clients) do
        if client.name == "grammarly" then
          vim.lsp.stop_client(client.id)
          return
        end
      end
      -- Start Grammarly client
      this.setup_lspconfig("grammarly", opts)
    end, { desc = "Toggle Grammarly", silent = true })
  end)
end

return M
