-- LSP plugins suuport
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

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
require("mason-lspconfig").setup({ ensure_installed = 
    {
        'pyright', 'bashls', 'clangd', 'html', 'texlab', 'ltex', 'lua_ls'
    } 
})

-- DAP
require("mason-nvim-dap").setup({ ensure_installed =
    {
        'python', 'cppdbg', 'bash'
    }
})

require('lint').linters_by_ft = {
    markdown = {'vale',},
    tex = {'vale',},
    c = {'cpplint',},
    cpp = {'cpplint',},
    python = {'flake8',},
    docker = {'hadolint',}
}

-- Linterns
require('mason-nvim-lint').setup({ ensure_installed = 
    {
        'cpplint', 'flake8', 'vale', 'hadolint'
    }
})
