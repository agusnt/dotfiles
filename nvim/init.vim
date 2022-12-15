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
" Spell Checker
Plug 'lewis6991/spellsitter.nvim'
" Cursor highlight
Plug 'yamatsum/nvim-cursorline'
" File Explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Gruvbox
Plug 'morhetz/gruvbox'
" Buffer as tab
Plug 'akinsho/nvim-bufferline.lua'
" Status line
Plug 'hoob3rt/lualine.nvim'
" Indent lines
Plug 'Yggdroot/indentLine'
" Glow
Plug 'ellisonleao/glow.nvim'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
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
" Luasinp
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()

"-------------------------------------------------------------------------------
" SpellChecker
"-------------------------------------------------------------------------------
lua require('spellsitter').setup()

"-------------------------------------------------------------------------------
" Status Line
"-------------------------------------------------------------------------------
lua require('lualine').setup{options = {theme = 'gruvbox'}}

"-------------------------------------------------------------------------------
" Bufferline 
"-------------------------------------------------------------------------------
lua require("bufferline").setup{options = {numbers = "buffer_id"}}

"-------------------------------------------------------------------------------
" Gruvbox
"-------------------------------------------------------------------------------
let g:gruvbox_italic=1
set background=dark
highlight Normal ctermbg=NONE
colorscheme gruvbox

"-------------------------------------------------------------------------------
" FileExplorer
"-------------------------------------------------------------------------------
lua require('nvim-tree').setup {}
let g:nvim_tree_quit_on_open = 0 "Close the tree when you open a file
let g:nvim_tree_indent_markers = 1 "Shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "Enable file highlight for git attributes.
let g:nvim_tree_highlight_opened_files = 1 "Enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~'
let g:nvim_tree_add_trailing = 1 "Append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 "Compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' '
let g:nvim_tree_symlink_arrow = ' ➛ '
let g:nvim_tree_respect_buf_cwd = 1 "Change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 1 "When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_refresh_wait = 1000 "Control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }

" Icons
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

" Keys to use NerdTree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

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
