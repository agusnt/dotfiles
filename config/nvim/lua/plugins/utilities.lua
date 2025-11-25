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
  -- Indent lines
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
  -- Dropbox Material
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
  -- Beautiful notifications
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end
  },
  -- Move between comments in the text
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        },
        TODO = { icon = " ", color = "info" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE",
        bg = "BOLD",
      },
      merge_keywords = true,
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#EA6962" },
        warning = { "DiagnosticWarn", "WarningMsg", "#D8A657" },
        info = { "DiagnosticInfo", "#A9B665" },
        hint = { "DiagnosticHint", "#7DAEA3" },
        default = { "Identifier", "#E78A4E" },
        test = { "Identifier", "#D3869B" }
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    }
  },
  -- Beautiful markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons" 
    },
    opts = {},
  }
}
