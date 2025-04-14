-- LSP configuration
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- These plugin will be duplicated, but I would like that every file can be run
  -- without using another
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts) require('lsp_signature').setup(opts) end
  },
  -- Save RAM not running in the background LSP servers
  -- {
  --   'zeioth/garbage-day.nvim',
  --   dependencies = 'neovim/nvim-lspconfig',
  --   event = 'VeryLazy',
  --   opts = {},
  -- },
  -- Easy goto function
  {
    'rmagatti/goto-preview',
    event = 'BufEnter',
    config = function()
      require('goto-preview').setup({})
    end
  },
  -- Action previews
  'aznhe21/actions-preview.nvim',
  -- Plugins to install
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- List of servers to configure
      local lsp_servers = loadfile('~/.config/nvim/lua/shared/lsp_servers.lua')()

      -- Signature helper
      local signature_helper = function(client, bufnr)
        require("better-diagnostic-virtual-text.api").setup_buf(bufnr, {})
      end

      -- Configure servers
      for _, lsp in pairs(lsp_servers) do
        require('lspconfig')[lsp].setup {
          on_attach = signature_helper,
          flags = {
            debounce_text_changes = 150,
          },
          capabilities = capabilities,
        }
      end

      -- clangd config
      require('lspconfig').clangd.setup({
        flags = { debounce_text_changes = 150 },
        cmd = {
          "clangd",
          "--background-index",
          -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
          -- to add more checks, create .clang-tidy file in the root directory
          -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
          "--clang-tidy",
          -- "--completion-style=bundled",
          "--cross-file-rename",
          "--header-insertion=iwyu",
        },
        on_attach = signature_helper,
      })

      -- Icons for SignColumn
      vim.cmd([[sign define DiagnosticSignError text=󰬅 texthl=TextError linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignWarn  text=󱈸 texthl=TextWarn  linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignInfo  text= texthl=TextInfo  linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignHint  text=󰋖 texthl=TextHint  linehl= numhl=]])
    end
  },
  -- Beautiful diagnostic
  {
    'sontungexpt/better-diagnostic-virtual-text',
    opts  = {
      ui = {
        wrap_line_after = true,
        left_kept_space = 3,
        right_kept_space = 3,
        arrow = "  ",
        up_arrow = "  ",
        down_arrow = "  ",
        above = false,
      },
      priority = 2003, -- the priority of virtual text
      inline = true,
    },
    event = 'VeryLazy',
  }
}
