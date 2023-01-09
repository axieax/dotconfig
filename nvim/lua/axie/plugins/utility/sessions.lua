local M = {}

M.cmd = "SessionManager"

M.keys = {
  {
    "<Space>fO",
    function()
      require("session_manager").load_session()
    end,
    desc = "Find sessions",
  },
}

function M.config()
  require("session_manager").setup({
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
  })
end

return M
