-- Debugging (loaded on first use from config/keymap.lua)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local dap, dapui = require('dap'), require('dapui')

dapui.setup({}) -- Scopes, stack, breakpoints and REPL panels
require('nvim-dap-virtual-text').setup({})

-- Open the UI when a session starts and close it when it ends
dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui'] = function() dapui.close() end

-- Adapters installed by Mason (config/servers.lua)
local mason = vim.fn.stdpath('data') .. '/mason'

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = { command = mason .. '/bin/codelldb', args = { '--port', '${port}' } },
}

dap.adapters.python = {
  type = 'executable',
  command = mason .. '/packages/debugpy/venv/bin/python',
  args = { '-m', 'debugpy.adapter' },
}

-- Ask for the executable to debug (C, C++ and Rust)
local function program()
  return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
end

local native = {
  { name = 'Launch', type = 'codelldb', request = 'launch', program = program,
    cwd = '${workspaceFolder}', stopOnEntry = false },
}
dap.configurations.c = native
dap.configurations.cpp = native
dap.configurations.rust = native

-- Python debugs the current file
dap.configurations.python = {
  { name = 'Launch file', type = 'python', request = 'launch', program = '${file}' },
}
