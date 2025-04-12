-- LSP configuration
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Save RAM not running in the background LSP servers
  {
    'zeioth/garbage-day.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    opts = {},
  },
  -- Easy goto function
  {
    'rmagatti/goto-preview',
    event = 'BufEnter',
    config = function()
      require('goto-preview').setup({})
    end
  },
  -- Action previews
  'aznhe21/actions-preview.nvim',
}
