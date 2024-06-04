-- LSP plugins support
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Servers
local lsp_server = {
    'pyright', 'bashls', 'clangd', 'html', 'texlab', 'ltex', 'lua_ls',
    'dockerls', 'docker_compose_language_service'
}
-- LSP
require("mason-lspconfig").setup({ ensure_installed = lsp_server })

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
    filetypes = { 'markdown', 'tex' },
    flags = { debounce_text_changes = 300 },
    settings = {
        ltex = {
            language = 'auto'
        }
    },
    on_attach = on_attach,
})

-- New icons for singcoloumn
vim.cmd([[sign define DiagnosticSignError text= texthl=TextError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=TextWarn  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text= texthl=TextInfo  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=TextHint  linehl= numhl=]])
