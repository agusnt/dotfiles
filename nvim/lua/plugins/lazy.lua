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
        'sainnhe/gruvbox-material',
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
    'nvim-telescope/telescope-fzy-native.nvim',
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {'kkharji/sqlite.lua', module = 'sqlite'},
    },
    -- LSP configuration
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        build = ":MasonUpdate"
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
    -- Buffer line
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    -- Smark marks
    'chentoast/marks.nvim',
    -- Leap
    'ggandor/leap.nvim',
    -- Nerd commander
    'numToStr/Comment.nvim',
    -- Editorconfig (remove it in neovim 0.9)
    'editorconfig/editorconfig-vim',
})
