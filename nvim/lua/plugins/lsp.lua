-- LSP plugins suuport
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local servers = { 'pyright', 'bashls', 'clangd', 'html', 'texlab', 'sumneko_lua'}

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

-- Automatic install lsop server
require("mason-lspconfig").setup({ ensure_installed = servers })

-- Autocompletation
local cmp = require'cmp'

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
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = capabilities,
    }
end;

-- New icons for singcoloumn
vim.cmd([[sign define DiagnosticSignError text= texthl=TextError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn  text= texthl=TextWarn  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo  text=כֿ texthl=TextInfo  linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint  text= texthl=TextHint  linehl= numhl=]])
