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
  {
    "romus204/referencer.nvim",
    config = function()
        require("referencer").setup()
    end
  },
  {
    "Dan7h3x/signup.nvim",
    branch = "main",
    config = function(_,opts)
      require("signup").setup(opts)
    end
  },
  {
    'Kasama/nvim-custom-diagnostic-highlight',
    config = function()
      require('nvim-custom-diagnostic-highlight').setup({})
    end
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function ()
      local lspconfig = require('lspconfig')
      lspconfig['clangd'].setup({})
      lspconfig['harper_ls'].setup({})
      lspconfig['pyright'].setup({})
      lspconfig['jqls'].setup({})
      lspconfig['html'].setup({})
      lspconfig['asm_lsp'].setup({})
      lspconfig['bashls'].setup({})
      lspconfig['gopls'].setup({})
    end
  }
}
