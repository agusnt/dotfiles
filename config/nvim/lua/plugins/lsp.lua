-- LSP configuration
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Save RAM not running in the background LSP servers
  {
    'zeioth/garbage-day.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    opts = {},
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
      require("actions-preview").setup({
      })
    end
  },
  {
    'Kasama/nvim-custom-diagnostic-highlight',
    config = function()
      require('nvim-custom-diagnostic-highlight').setup({
        diff = {
          ctxlen = 3,
        },

        -- priority list of preferred backend
        backend = { "telescope" },

        -- options related to telescope.nvim
        telescope = vim.tbl_extend(
          "force",
          require("telescope.themes").get_dropdown(),
          {
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
              width = 0.8,
              height = 0.9,
              prompt_position = "top",
              preview_cutoff = 20,
              preview_height = function(_, _, max_lines)
                return max_lines - 15
              end,
            },
          }
        ),
      })
    end
  },
  -- LSP
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "jqls",
        "html",
        "gopls",
        "texlab",
        "clangd",
        "bashls",
        "pyright",
        "asm_lsp",
        "harper_ls",
      },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    }
  },
  -- Ensure installed for mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "jqls",
        "html",
        "gopls",
        "texlab",
        "clangd",
        "bashls",
        "pyright",
        "asm_lsp",
        "harper_ls",

        -- Lintern
        "jsonlint",
        "shellcheck",
        "markdownlint",
        
        -- Formatter
        "ruff",
        "shfmt",
        "bibtex-tidy",
        "clang-format",
      },
      auto_update = true
    },
  }
}
