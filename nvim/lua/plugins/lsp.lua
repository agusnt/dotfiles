-- LSP plugins suuport
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local servers = { 'pyright', 'bashls', 'clangd', 'html', 'texlab', 'sumneko_lua'}

-- Configure mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
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
end

-- Info
lspmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
-- Goto definition
lspmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
-- Goto declaration
lspmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
-- Goto Implementation
lspmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
-- Goto type definition
lspmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
-- List references
lspmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
-- Show arguments
lspmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
-- Show symbols
lspmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
-- List options
lspmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
lspmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
-- Open diagnostic
lspmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
lspmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
lspmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- >> Telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { silent = true })
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { silent = true })
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { silent = true })
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", { silent = true })
map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", { silent = true })
map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", { silent = true })


