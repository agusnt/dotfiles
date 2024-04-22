-- LSP,DAP,Linterns,Formatter plugins suuport
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Servers
local lsp_server = {
    'pyright', 'bashls', 'clangd', 'html', 'texlab', 'ltex', 'lua_ls',
    'dockerls', 'docker_compose_language_service'
}
local dap_server = {
    'python', 'cpptools', 'bash'
}
local lint_server =  {
    'cpplint', 'flake8', 'vale', 'hadolint'
}

-- Configure mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "->",
            package_uninstalled = "X"
        }
    }
})

-- LSP
require("mason-lspconfig").setup({ ensure_installed = lsp_server })

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

-- Lint
require('lint').linters_by_ft = {
    markdown = {'vale',},
    tex = {'vale',},
    c = {'cpplint',},
    cpp = {'cpplint',},
    python = {'flake8',},
    docker = {'hadolint',}
}

-- Linterns
require('mason-nvim-lint').setup({ ensure_installed = lint_server })

-- Formatter
require("formatter").setup()

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

-- Autocompletation
local cmp = require('cmp')

-- Neodev, should go before lspconfig
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

cmp.setup({
    snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end,},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources(
    {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
        { name = 'orgmode' },
    }
    )
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, lsp in pairs(lsp_server) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = capabilities,
    }
end;

-- ltex config
require('lspconfig').ltex.setup({
    filetypes = { "vimwiki", "markdown", "md", "pandoc", "vimwiki.markdown.pandoc" },
    flags = { debounce_text_changes = 300 },
    settings = {
        ltex = {
            language = "auto"
        }
    },
    on_attach = on_attach,
})

-- New icons for singcoloumn
vim.cmd([[sign define DiagnosticSignError text= texthl=TextError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=TextWarn  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=TextInfo  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=TextHint  linehl= numhl=]])
