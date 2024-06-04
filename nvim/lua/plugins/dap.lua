-- DAP plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local dap_server = {
    'python', 'cpptools', 'bash'
}

-- DAP
require("mason-nvim-dap").setup({
    ensure_installed = dap_server,
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
            config.configurations = {
                {
                    type = 'python',
                    request = 'launch',
                    program = '${file}',
                    args = function()
                        local args_string = vim.fn.input("Input arguments: ")
                        return vim.split(args_string, " ")
                    end
                }
            }
            require('mason-nvim-dap').default_setup(config)
        end,
        cppdbg = function(config)
            config.configurations = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    args = function()
                        local args_string = vim.fn.input("Input arguments: ")
                        return vim.split(args_string, " ")
                    end,
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopAtEntry = true,
                },
                {
                    name = 'Attach to gdbserver :1234',
                    type = 'cppdbg',
                    request = 'launch',
                    MIMode = 'gdb',
                    miDebuggerServerAddress = 'localhost:1234',
                    miDebuggerPath = '/usr/bin/gdb',
                    cwd = '${workspaceFolder}',
                    args = function()
                        local args_string = vim.fn.input("Input arguments: ")
                        return vim.split(args_string, " ")
                    end,
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                },
            }
            require('mason-nvim-dap').default_setup(config)
        end
    }
})

-- DAP-UI
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

-- Neodev, should go before lspconfig
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})
