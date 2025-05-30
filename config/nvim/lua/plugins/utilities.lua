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
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_background = 'hard'
      vim.g.gruvbox_enable_italic = true
      vim.cmd.colorscheme('gruvbox-material')
    end
  },
  -- Beutiful notifications
  {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup({})
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = 'latexrun'
    end
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
  }
}
