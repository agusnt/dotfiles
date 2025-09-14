-- Utility plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Comment code
  {
    'numToStr/Comment.nvim',
    config = function()
      require("Comment").setup()
    end
  },
  -- Ident lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  -- Marks
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- Faster movement
  {
    'ggandor/leap.nvim',
    dependencies = 'tpope/vim-repeat',
  },
  -- Gruvbox Material
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_background = 'dark'
      vim.g.gruvbox_enable_italic = true
      vim.cmd.colorscheme('gruvbox')
    end
  },
  -- Beutiful notifications
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
      bigfile = {
        size = 5 * 1024 * 1024
      }
    }
  },
  {
    "sontungexpt/better-diagnostic-virtual-text",
    config = function(_)
      require('better-diagnostic-virtual-text').setup(opts)
    end
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons" 
    },
    opts = {},
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  }
}
