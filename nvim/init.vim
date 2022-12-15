" Install and run
" python3 -m pip install --user --upgrade pynvim

"------------------------------------------------------------------
" Syntax, number, limit, encoding, tab, fold, backspace, spell
"------------------------------------------------------------------
syntax on  " Highlight syntax
set ruler  " Show position of the cursor in status bar
let mapleader = "," " Change MapLeader

" Vertical line and wrap
set textwidth=0   " Maximum width of column
set wrapmargin=0
set wrap
set linebreak " Breaks by word rather than character
set colorcolumn=80 " Change color

" Tab configuration, space instead of tab, 4-size
set tabstop=4 shiftwidth=4 expandtab
set backspace=indent,eol,start

" Encode and spell
set encoding=utf-8
set spelllang=en

" Number relatives
set number relativenumber
set nu rnu

" Highlight cursor line
set cursorline     
set cursorcolumn

" Italic Comments
highlight Comment cterm=italic

" Incremental search
set incsearch

" Folding options
set foldmethod=syntax " Way to fold
set foldnestmax=3     " Maximum fold

" Set spell
set spell

" Merge signcolumn and number column into one
set signcolumn=no

" This variable must be enabled for colors to be applied properly
set termguicolors 

" To prevent conceal
let g:indentLine_setConceal=0 " Use nvim conceal
set conceallevel=2

"-------------------------------------------------------------------------------
" Movements
"-------------------------------------------------------------------------------

" >> Buffers <<
" Open a new buffer
nmap <leader>T :enew<cr> 
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>
" Fast move between buffers (more than 9 has an small delay)
for i in range(1, 9)
    execute 'nnoremap <Leader>b'.i.
        \ ' :buffer '.i.'<CR>'
endfor

"-------------------------------------------------------------------------------
" Plugins
"-------------------------------------------------------------------------------

call plug#begin('~/.local/share/nvim/plugged')
" >> Plugins to install <<
" Install plugins with :PlugInstall

" VimWiki
Plug 'vimwiki/vimwiki'
" Gruvbox
Plug 'morhetz/gruvbox'
" Status line
Plug 'hoob3rt/lualine.nvim'
" Glow
Plug 'ellisonleao/glow.nvim'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
" LSP configuration
Plug 'neovim/nvim-lspconfig'
" Automatic LSP installer
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Luasnip
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()

"-------------------------------------------------------------------------------
" Status Line
"-------------------------------------------------------------------------------
lua require('lualine').setup{options = {theme = 'gruvbox'}}

"-------------------------------------------------------------------------------
" Gruvbox
"-------------------------------------------------------------------------------
let g:gruvbox_italic=1
set background=dark
highlight Normal ctermbg=NONE
colorscheme gruvbox

"-------------------------------------------------------------------------------
" Special options for specific stuff
"-------------------------------------------------------------------------------

" Python fold by indent instead of syntax
autocmd Filetype python set foldmethod=indent

" Makefile tabs 8-size instead of spaces 4-size
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

"-------------------------------------------------------------------------------
" Glow
"-------------------------------------------------------------------------------
lua require('glow').setup({style = "dark", width = 120,})
nmap <leader>g :Glow<cr>

"-------------------------------------------------------------------------------
" LSP
"-------------------------------------------------------------------------------
set completeopt=menu,menuone,noselect

lua << EOF
local servers = { 'pyright', 'bashls', 'clangd', 'html', 'texlab', }

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

EOF

" Move between definitions
nnoremap <leader> gD (lsp-declaration)<cr>
nnoremap <leader> gd (lsp-definition)<cr>
nnoremap <leader> gi (lsp-implementation)<cr>

nnoremap <leader> D (lsp-type_definition)<cr>
nnoremap <leader> rn (lsp-rename)<cr>
nnoremap <leader> gr (lsp-references)<cr>

nnoremap <leader> K  (lsp-hover)<cr>
nnoremap <leader> sh (lsp-signature_help)<cr>


"-------------------------------------------------------------------------------
" Telescope   
"-------------------------------------------------------------------------------
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>fa <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>fo <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>

"-------------------------------------------------------------------------------
" VimWiki     
"-------------------------------------------------------------------------------
" Work 
let g:vimwiki_list = [{
            \ 'path': '~/Documents/Wiki/Work/',
            \ 'syntax': 'markdown',
            \ 'ext': '.md', }]
