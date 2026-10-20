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
})

-- Servers are enabled in config/lsp.lua; this plugin is kept only for its
-- lspconfig <-> Mason name mapping
require("mason-lspconfig").setup({
  automatic_enable = false,
})
