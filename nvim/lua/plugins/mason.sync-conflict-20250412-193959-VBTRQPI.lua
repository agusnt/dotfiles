-- Mason plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local servers = {}

-- Get all the servers in one array
local function concatServers(a)
  for _, v in ipairs(a) do
    table.insert(servers, v)
  end
end

-- Load servers from other file
concatServers(loadfile('~/.config/nvim/lua/shared/lsp_servers.lua')())
concatServers(loadfile('~/.config/nvim/lua/shared/dap_servers.lua')())
concatServers(loadfile('~/.config/nvim/lua/shared/formatter_servers.lua')())

return {
  {
    'williamboman/mason.nvim',
    config = function()
      -- Configure mason
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  -- Linterns, can not be installed with mason-tool-installer
  {
    'rshkarin/mason-nvim-lint',
    -- Install linterns
    config = function()
      require('mason-nvim-lint').setup({
        ensure_installed = loadfile('~/.config/nvim/lua/shared/lint_servers.lua')(),
        automatic_installation = true,
      })
    end
  },
  -- DAP, Formatter, and LSP config
  'jay-babu/mason-nvim-dap.nvim',
  'zapling/mason-conform.nvim',
  'williamboman/mason-lspconfig.nvim',
  {
    'WhoIsSethDaniel/mason-tool-installer',
    -- Config everythin
    config = function()
      -- Configure tools that we want to install
      require('mason-tool-installer').setup({
        ensure_installed = servers,
        -- Autoamtic updates
        auto_update = true,
        run_on_start = true,
        -- Delay before start to install
        start_delay = 3000,
        -- Not update everytime that I open neovim, only every 24h
        -- debounce_hours = 24,
      })
    end,
  }
}
