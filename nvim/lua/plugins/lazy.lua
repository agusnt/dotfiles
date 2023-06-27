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

require('lazy').setup({
    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    -- Gruvbox
    { 'sainnhe/gruvbox-material', priority = 1000 },
    -- Status line
    { 'hoob3rt/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },
    -- Telescope
    { 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' },
    { 
        'nvim-telescope/telescope-file-browser.nvim', 
        dependencies = 'nvim-telescope/telescope.nvim'
    },
    {
        'nvim-telescope/telescope-fzy-native.nvim',
        dependencies = 'nvim-telescope/telescope.nvim'
    },
    -- Luasnip
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    -- Indent line
    'lukas-reineke/indent-blankline.nvim',
    -- Leap
    'ggandor/leap.nvim',
    -- Nerd commander
    'numToStr/Comment.nvim',
    -- Autopairs
    'windwp/nvim-autopairs',
    -- Glow 
    'ellisonleao/glow.nvim',

    -- Comment this plugins if you don't want to have lsp (and save resources)
    -- LSP configuration
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    -- Autocompletion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp'

})
