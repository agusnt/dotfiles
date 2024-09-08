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
    -- Color Schema
    { 'ellisonleao/gruvbox.nvim', lazy = false, priority = 1000 },
    -- Telescope
    { 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' },
    {
        'nvim-telescope/telescope-fzy-native.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        }
    },
    -- Luasnip
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    -- Indent line
    { 'lukas-reineke/indent-blankline.nvim', main = "ibl", opts = {} },
    -- Leap
    'ggandor/leap.nvim',
    -- Nerd commander
    'numToStr/Comment.nvim',
    -- Autopairs
    'windwp/nvim-autopairs',
    -- Glow 
    { 'ellisonleao/glow.nvim', config = true, cmd = 'Glow' },
    -- Mason
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'rshkarin/mason-nvim-lint',
    'williamboman/mason-lspconfig.nvim',
    -- LSP, DAP, LIN, FORMATTER configuration
    'mhartington/formatter.nvim',
    'folke/neodev.nvim',
    'mfussenegger/nvim-lint',
    'theHamsta/nvim-dap-virtual-text',
    'neovim/nvim-lspconfig',
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'}
    },
    -- Autocompletion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    { 'zbirenbaum/copilot-cmp', dependencies = { 'zbirenbaum/copilot.lua' } },
    -- Oil
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    -- Marks
    'chentoast/marks.nvim',
    -- Latex
    { 'lervag/vimtex', lazy = false },
    -- askGemini
    {
        'agusnt/askGemini.nvim',
        dependencies = { 'MunifTanjim/nui.nvim' }
    }
})
