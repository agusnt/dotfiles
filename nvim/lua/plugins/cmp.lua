-- LSP cmp config
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local cmp = require('cmp')
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
    sources = {
        {name = 'copilot', group_index = 2, keyword_length = 2 },
        {name = 'luasnip', group_index = 2, keyword_length = 2 },
        {name = 'nvim_lsp', group_index = 2 },
        {name = 'path', group_index = 2 },
        {name = 'buffer', group_index = 2, keyword_length = 4 },
    }
})

