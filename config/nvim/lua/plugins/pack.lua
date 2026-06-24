-- vim pack installation
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.pack.add({
  -- CMP plugins
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = "https://github.com/saghen/blink.lib" },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/Kaiser-Yang/blink-cmp-dictionary' },
  -- Formatter
  { src = 'https://github.com/stevearc/conform.nvim' },
  -- Lintern
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  -- Lualine
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  -- Telescope
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzy-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim' },
  -- Neorg
  { src = 'https://github.com/nvim-neorg/neorg' },
  { src = 'https://github.com/nvim-neorg/tree-sitter-norg' },
  { src = 'https://github.com/nvim-neorg/tree-sitter-norg-meta' },
  { src = 'https://github.com/nvim-neorg/lua-utils.nvim' },
  { src = 'https://github.com/pysan3/pathlib.nvim' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/3rd/image.nvim' },
  -- Vimtex
  { src = 'https://github.com/lervag/vimtex' },
  -- Code action
  { src = 'https://github.com/rachartier/tiny-code-action.nvim' },
  -- Colorizer
  { src = 'https://github.com/norcalli/nvim-colorizer.lua' },
  -- TODO comments
  { src = 'https://github.com/folke/todo-comments.nvim' },
  -- Material
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
  -- Leap
  { src = 'https://codeberg.org/andyg/leap.nvim' },
  -- Marks
  { src = 'https://github.com/chentoast/marks.nvim' },
  -- Ident lines
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  -- Treesitter
  { src = 'https://github.com/arborist-ts/arborist.nvim' },
  -- Comment 
  { src = 'https://github.com/numToStr/Comment.nvim' },
  -- Common dependencies
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  -- Mason
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
})
