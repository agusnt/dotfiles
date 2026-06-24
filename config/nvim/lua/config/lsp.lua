-- LSP plugin (Neovim 0.12+ con vim.lsp.config)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- 1. Lua
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', 'stylua.toml' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
    on_attach = on_attach,
})

-- 2. Bash
vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.bashrc', '.bash_profile' },
    on_attach = on_attach,
})

-- 3. Clangd (C/C++)
vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index', '--clang-tidy' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'Makefile' },
    on_attach = on_attach,
})

-- 4. Python (basedpyright)
vim.lsp.config('basedpyright', {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
    on_attach = on_attach,
})

-- 5. LaTeX (texlab)
vim.lsp.config('texlab', {
    cmd = { 'texlab' },
    filetypes = { 'tex', 'latex' },
    root_markers = { '.latexmkrc', 'main.tex' },
    settings = {
        texlab = {
            build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1' },
                onSave = true,
            },
            forwardSearch = {
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
            },
        },
    },
    on_attach = on_attach,
})

-- 6. Rust (rust-analyzer)
vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json' },
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = { command = 'clippy' },
        },
    },
    on_attach = on_attach,
})

-- 7. ASM
vim.lsp.config('asm-lsp', {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm' },
    root_markers = { '.git' },
    on_attach = on_attach,
})

-- 8. CMake (neocmake)
vim.lsp.config('neocmake', {
    cmd = { 'neocmakelsp' },
    filetypes = { 'cmake' },
    root_markers = { 'CMakeLists.txt', '.git' },
    on_attach = on_attach,
})

-- 9. Docker
vim.lsp.config('dockerls', {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile', '.git' },
    on_attach = on_attach,
})

-- 10. JSON
vim.lsp.config('jsonls', {
    cmd = { 'json-lsp' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { '.git', 'package.json' },
    settings = {
        json = {
            validate = { enable = true },
        },
    },
    on_attach = on_attach,
})

-- 11. Harper (corrección ortográfica)
vim.lsp.config('harper_ls', {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'text', 'latex' },
    root_markers = { '.git' },
    settings = {
        ['harper-ls'] = {
            languages = { 'markdown', 'latex', 'text', 'comment', 'string' },
            diagnosticSeverity = 'warning',
        },
    },
    on_attach = on_attach,
})

-- 12. Markdown (Marksman)
vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown' },
    root_markers = { '.marksman.toml', '.git' },
    on_attach = on_attach,
})

-- ===== ACTIVAR LSP AUTOMÁTICAMENTE =====
-- En Neovim 0.12, vim.lsp.config registra los servidores
-- y se activan automáticamente al abrir archivos.

-- ===== DIAGNÓSTICOS =====
vim.diagnostic.config({
    signs = false,
    virtual_text = true,
    severity_sort = true,
})

local function sign_define(args)
    vim.fn.sign_define(args.name, {
        texthl = args.name,
        text = args.text,
        numhl = ''
    })
end

sign_define({name = 'DiagnosticSignError', text = ''})
sign_define({name = 'DiagnosticSignWarn', text = ''})
sign_define({name = 'DiagnosticSignHint', text = ''})
sign_define({name = 'DiagnosticSignInfo', text = ''})
