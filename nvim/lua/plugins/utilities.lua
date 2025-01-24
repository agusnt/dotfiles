-- Utility plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Comment code
  'numToStr/Comment.nvim',
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
  -- Gruvbox
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000
  },
  -- Beutiful notifications
  {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup({})
    end
  },
}
