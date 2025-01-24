-- CMP plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  -- Beautiful CMP icons
  'onsails/lspkind.nvim',
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local lspkind = require('lspkind')
      local cmp = require('cmp')
      cmp.setup({
        -- To add luasnip
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = {
              menu = 50,
              abbr = 50,
            },
            ellipsis_char = '...',
            show_labelDetails = true,
          }),
        },

        -- Pretty windows
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- Update mapping keyboards
        mapping = cmp.mapping.preset.insert({
          ['<C-b>']     = cmp.mapping.scroll_docs(-4),
          ['<C-f>']     = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>']     = cmp.mapping.abort(),
          ['<CR>']      = cmp.mapping.confirm({ select = true }),
        }),

        -- Configure sources
        sources = {
          { name = 'nvim_lsp_signature_help', group_index = 2 },
          { name = 'dap',                     group_index = 2 },
          { name = 'luasnip',                 group_index = 2, keyword_length = 2 },
          { name = 'nvim_lsp',                group_index = 2 },
          { name = 'path',                    group_index = 2 },
          { name = 'buffer',                  group_index = 2, keyword_length = 4 },
        }
      })
    end
  },
}
