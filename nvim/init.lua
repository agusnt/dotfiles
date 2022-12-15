-- Install and run
-- python3 -m pip install --user --upgrade pynvim

-------------------------------------------------------------------------------
-- Packer
-------------------------------------------------------------------------------
require('packer').startup(function(use)
    -- >> Plugins to install
    -- Install plugins with :PackerInstall
    -- Update plugins with :PackerUpdate
    -- List installed plugins with :PackerStatus
    
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- VimWiki
    use {
        'vimwiki/vimwiki',
        config = function()
            vim.g.vimwiki_list = {
                {
                    path   = '~/Documents/Wiki/Work/',
                    syntax = 'markdown',
                    ext    = '.md', 
                }
            }
        end
    }
    -- Gruvbox
    use { "ellisonleao/gruvbox.nvim" }
    -- Status line
    use 'hoob3rt/lualine.nvim'
    -- Glow
    use 'ellisonleao/glow.nvim'
    -- Telescope
    use {
  	    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  	    requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-telescope/telescope-file-browser.nvim'
    -- LSP configuration
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig'
    }
    -- Autocompletion
    use {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp'
    }
    -- Luasnip
    use {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
    }
    -- Bufferline
    use {
        'akinsho/bufferline.nvim', 
        tag = "v3.*", 
        requires = 'nvim-tree/nvim-web-devicons'
    }
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
    }
    -- Indent line
    use 'lukas-reineke/indent-blankline.nvim'
    -- Impatient
    use 'lewis6991/impatient.nvim' 
end)

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
function map(mode, lhs, rhs, opts)
    --[[
    Map keys to functions

    Parameters:
        mode : Vim modes (Normal/Insert/Visual)
        lhs  : keybinds
        rhs  : commands
        opts : additional options like <silent>/<noremap>
    --]]
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function lspmap(mode, lhs, rhs)
  --[[
    Map keys to functions

    Parameters:
        mode : Vim modes (Normal/Insert/Visual)
        lhs  : keybinds
        rhs  : commands
    --]]
    local opts = {buffer = true}
    vim.keymap.set(mode, lhs, rhs, opts)
end


-------------------------------------------------------------------------------
-- Syntax, number, limit, encoding, tab, fold, backspace, spell
-------------------------------------------------------------------------------
vim.o.syntax    = on  -- Highlight syntax
vim.g.mapleader = "," -- Change MapLeader

-- Vertical line and wrap
vim.bo.textwidth   = 0  -- Maximum width of column
vim.bo.wrapmargin  = 0
vim.wo.wrap        = true
vim.wo.linebreak   = true     -- Breaks by word rather than character
vim.wo.colorcolumn = 80 -- Change color

-- Tab configuration, space instead of tab, 4-size
vim.bo.tabstop    = 4 
vim.bo.shiftwidth = 4 
vim.bo.expandtab  = true
vim.o.backspace   = indent,eol,start

-- Encode and spell
vim.o.encoding  = "utf-8"
vim.o.spelllang = "en"

-- Number relatives
vim.wo.number = relativenumber
vim.o.nu      = true
vim.o.rnu     = true

-- Highlight cursor line
vim.o.cursorline   = true
vim.o.cursorcolumn = true

-- Italic Comments
vim.api.nvim_set_hl(0, 'Comment', {italic})

-- Set spell
vim.o.spell = true

-- Merge signcolumn and number column into one
vim.o.signcolumn = "no"

-- This variable must be enabled for colors to be applied properly
vim.o.termguicolors = true

-- To prevent conceal
vim.g.indentLine_setConceal = 0 -- Use nvim conceal
vim.o.conceallevel=2

-- Fold
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-------------------------------------------------------------------------------
-- Movements
-------------------------------------------------------------------------------

-- >> Buffers

-- Open a new buffer
map("n", "<leader>T", ":enew<CR>", { silent = true })
-- Move to the next buffer
map("n", "<leader>l", ":bnext<CR>", { silent = true })
-- Move to the previous buffer
map("n", "<leader>h", ":bprevious<CR>", { silent = true })
-- Close the current buffer and move to the previous one
map("n", "<leader>bq", ":bp <BAR> bd #<CR>", { silent = true })

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

-- >> Gruvbox 
vim.o.background = "dark" -- or light
vim.cmd([[colorscheme gruvbox]])

-- >> LuaLine
require('lualine').setup{options = {theme = 'gruvbox'}}

-- >> Glow 
require('glow').setup({style = "dark", width = 120,})
map("n", "<leader>g", ":Glow<cr>", { silent = true })

-- >> LSP
local servers = { 'pyright', 'bashls', 'clangd', 'html', 'texlab'}

-- Configure mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Automatic install lsop server
require("mason-lspconfig").setup({ ensure_installed = servers })

-- Autocompletation
local cmp = require'cmp'

cmp.setup({
    snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end,},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = capabilities,
    }
end

-- Info
lspmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
-- Goto definition
lspmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
-- Goto declaration
lspmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
-- Goto Implementation
lspmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
-- Goto type definition
lspmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
-- List references
lspmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
-- Show arguments
lspmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
-- Show symbols
lspmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
-- List options
lspmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
lspmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
-- Open diagnostic
lspmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
lspmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
lspmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- >> Telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { silent = true })
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { silent = true })
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { silent = true })
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", { silent = true })
map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", { silent = true })
map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", { silent = true })

-- >> Bufferline
require("bufferline").setup{}

-- >> TreeSitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names
  ensure_installed = { "c", "bash", "python", "cpp", "lua", "rust", "latex", "latex" },
  sync_install = false, -- Install sync
  auto_install = true,

  highlight = { enable = true, },
}

-- >> Indent lines
require("indent_blankline").setup {
    show_current_context = true,
}

-- >> Impatient
require('impatient')
