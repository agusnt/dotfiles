--- Mason plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local servers = require('config/servers')

require("mason").setup({
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = ""
    }
  }
})

-- One install list: every language server plus the extra tools
local ensure_installed = vim.tbl_values(servers.lsp)
vim.list_extend(ensure_installed, servers.tools)

require('mason-tool-installer').setup({
  ensure_installed = ensure_installed,
  auto_update = false, -- update on demand with :MasonToolsUpdate
  run_on_start = true,
  start_delay = 3000, -- Check the tools after startup, not during it
})

-- Servers are enabled in config/lsp.lua (defaults from nvim-lspconfig)
