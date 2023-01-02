--- Packer plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('packer').startup(function(use)
    -- >> Plugins to install
    -- Install plugins with :PackerInstall
    -- Update plugins with :PackerUpdate
    -- List installed plugins with :PackerStatus

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- VimWiki
    use {
        'vimwiki/vimwiki',
        config = function()
            vim.g.vimwiki_list = {
                {
                    path   = '~/Documents/Wiki/Work/',
                    syntax = 'markdown',
                    ext    = '.md', 
                }
            }
        end
    }
    -- Gruvbox
    use { "ellisonleao/gruvbox.nvim" }
    -- Status line
    use 'hoob3rt/lualine.nvim'
    -- Glow
    use 'ellisonleao/glow.nvim'
    -- Telescope
    use {
  	    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  	    requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-telescope/telescope-file-browser.nvim'
    -- LSP configuration
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }
    -- Autocompletion
    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp'
    }
    -- Luasnip
    use {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
    }
    -- Treesitter
    use 'nvim-treesitter/nvim-treesitter'
    -- Indent line
    use 'lukas-reineke/indent-blankline.nvim'
    -- Impatient
    use 'lewis6991/impatient.nvim'
    -- Buffer line
    use {
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons'
    }
end)
