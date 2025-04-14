-- CMP plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  { 'tzachar/cmp-fuzzy-path',                   dependencies = { 'tzachar/fuzzy.nvim' } },
  { 'tzachar/cmp-fuzzy-buffer',                 dependencies = { 'tzachar/fuzzy.nvim' } },
  {
    'uga-rosa/cmp-dictionary',
    config = function()
      require('cmp_dictionary').setup({
        paths = { "/usr/share/dict/words" },
        exact_length = 2,
      })
    end
  },
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-calc',
  -- Beautiful CMP icons
  'rcarriga/cmp-dap',
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
            mode = 'symbol_text',
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
          { name = 'nvim_lsp',                 max_item_count = 8, group_index = 1, keyword_length = 2 },
          { name = 'nvim_lsp_signature_help',  max_item_count = 8, group_index = 1, keyword_length = 2 },
          { name = 'nvim_lsp_document_symbol', max_item_count = 8, group_index = 1, keyword_length = 2 },
          { name = 'luasnip',                  max_item_count = 8, group_index = 1, keyword_length = 2 },

          { name = 'fuzzy_path',               max_item_count = 4, group_index = 2, keyword_length = 2 },

          { name = 'dap',                      max_item_count = 4, group_index = 3, keyword_length = 2 },

          { name = 'dictionary',               max_item_count = 4, group_index = 4, keyword_length = 2 },
          { name = 'calc',                     max_item_count = 4, group_index = 4, keyword_length = 2 },

          { name = 'fuzzy_buffer',             max_item_count = 4, group_index = 5, keyword_length = 2 },
        }
      })
    end
  },
}
