"------------------------------------------------------------------
" Syntax, number, limit, encoding, tab, fold, backspace, spell
"------------------------------------------------------------------

syntax on  " Highlight syntax
set ruler  " Show position of the cursor in status bar
let mapleader = "," " Change MapLeader

" TextEdit might fail if hidden is not set.
set hidden

" Vertical line
set textwidth=80   " Maximum width of column
set colorcolumn=+1 " Change color

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

" Show buffers like tabs
set hidden 
set showtabline=2  

" Incremental search
set incsearch

" Folding options
set foldmethod=syntax " Way to fold
set foldnestmax=2     " Maximum fold

" Set spell
set spell

" Merge signcolumn and number column into one
set signcolumn=number

" This variable must be enabled for colors to be applied properly
set termguicolors 

" To prevent conceal
let g:indentLine_setConceal=0 " Use nvim conceal
set conceallevel=2
set concealcursor=v

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

"-------------------------------------------------------------------------------
" Plugins
"-------------------------------------------------------------------------------

call plug#begin('~/.local/share/nvim/plugged')
" >> Plugins to install <<
" Install plugins with :PlugInstall

" Spell Checker
Plug 'lewis6991/spellsitter.nvim'
" Cursor highlight
Plug 'yamatsum/nvim-cursorline'
" File Explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Git blame
Plug 'f-person/git-blame.nvim'
" Gruvbox
Plug 'morhetz/gruvbox'
" Registers Peek
Plug 'gennaro-tedesco/nvim-peekup'
" Buffer as tab
Plug 'akinsho/nvim-bufferline.lua'
" Tag bar
Plug 'liuchengxu/vista.vim'
" Status line
Plug 'hoob3rt/lualine.nvim'
" ALE Lint engine
Plug 'dense-analysis/ale'
" Indent lines
Plug 'Yggdroot/indentLine'
" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Glow
Plug 'ellisonleao/glow.nvim'
" Latex
Plug 'lervag/vimtex'
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
" Tag Bar
"-------------------------------------------------------------------------------
nmap <leader>o :Vista<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
lua require("bufferline").setup{} 

"-------------------------------------------------------------------------------
" Enable Git Blame
"-------------------------------------------------------------------------------
let g:gitblame_enabled = 0

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

" Folde Icon background
highlight NvimTreeFolderIcon guibg=blue

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
let g:glow_border = "rounded"

"-------------------------------------------------------------------------------
" COC (Autocomplete) 
"-------------------------------------------------------------------------------
" Language supports for C/C++ install clangd
let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-tsserver',
            \ 'coc-pyright',
            \ 'coc-html',
            \ 'coc-markdownlint',
            \ 'coc-rust-analyzer',
            \ 'coc-texlab',
            \ 'coc-clangd',
            \ ]

" Ctrl + Space trigger COC
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>

"-------------------------------------------------------------------------------
" VimLatex 
"-------------------------------------------------------------------------------
let g:vimtex_compiler_method = 'pdflatex'
let g:vimtex_view_general_viewer = 'open -a Preview'
