-- Syntax, number, limit, encoding, tab, fold, backspace, spell
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.g.mapleader      = ","    -- Change mapleader
vim.g.maplocalleader = "\\"

-- Tab configuration, space instead of tab, 2-size
vim.opt.expandtab    = true -- True for using spaces instead of tab
vim.opt.tabstop      = 2
vim.opt.shiftwidth   = 2
vim.o.backspace      = "indent,eol,start"

-- Search, editing and window behaviour
vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.inccommand = "split"  -- Live preview of :s
vim.o.undofile   = true     -- Persistent undo
vim.o.scrolloff  = 8
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 250
vim.o.cursorline = true

-- Encode and spell
vim.o.spelllang = "en"
vim.o.spell     = false

-- Number relatives
vim.o.nu        = true
vim.o.rnu       = true
--vim.wo.statuscolumn  = '%=%s %=%r '

-- Merge signcolumn and number column into one
vim.o.signcolumn = "yes:1"

-- This variable must be enabled for colors to be applied properly
vim.o.termguicolors = true

-- Conceal only where it is wanted (it hides quotes in JSON/Markdown otherwise)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'norg', 'tex', 'plaintex', 'markdown' },
  callback = function() vim.wo.conceallevel = 2 end,
})

-- Fold
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevelstart = 99 -- Everthing unfolding

-- Smart indent
vim.opt.smartindent = false

-- Indent while wrapping
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- Special characters
vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  eol = '↵',
}
-- SpecialKey is set in config/colorschema.lua (a colorscheme would clear it here)

-- DNS server
vim.env.HOSTALIASES = "/dev/null"
vim.env.NODE_OPTIONS = "--dns-result-order=ipv4first"

vim.g.tex_flavor = "latex"
