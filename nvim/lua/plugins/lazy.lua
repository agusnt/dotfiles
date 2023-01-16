--- Lazy plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Ensure lazy nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.vimwiki_global_ext = 0 -- Markdown not always as markdown

require('lazy').setup({
    -- VimWiki
    {
        'vimwiki/vimwiki',
        config = function()
            vim.g.vimwiki_list = {
                {
                    path   = '~/Documents/Wiki/Work/',
                    syntax = 'markdown',
                    ext    = '.md',
                },
            }
        end
    },
    -- Gruvbox
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,
        priority = 1000,
    },
    -- Status line
    'hoob3rt/lualine.nvim',
    -- Glow
    'ellisonleao/glow.nvim',
    -- Telescope
    {
  	    'nvim-telescope/telescope.nvim',
  	    dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    'nvim-telescope/telescope-file-browser.nvim',
    'benfowler/telescope-luasnip.nvim',
    -- LSP configuration
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    },
    -- Autocompletion
    {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp'
    },
    -- Luasnip
    {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
    },
    -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    -- Indent line
    'lukas-reineke/indent-blankline.nvim',
    -- Impatient
    'lewis6991/impatient.nvim',
    -- Buffer line
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    -- Peekup
    'gennaro-tedesco/nvim-peekup',
})
