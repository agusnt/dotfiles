-- Syntax, number, limit, encoding, tab, fold, backspace, spell
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.o.syntax         = enable -- Highlight syntax
vim.g.mapleader      = ","    -- Change mapleader
vim.g.maplocalleader = "\\"

-- Tab configuration, space instead of tab, 4-size
vim.opt.expandtab    = true -- True for using spaces instead of tab
vim.opt.tabstop      = 2
vim.opt.shiftwidth   = 2
vim.g.backspace      = indent, eol, start

-- Encode and spell
vim.o.encoding       = "utf-8"
vim.o.spelllang      = "en"
vim.opt.spell        = false

-- Number relatives
vim.wo.number        = relativenumber
vim.o.nu             = true
vim.o.rnu            = true
vim.wo.statuscolumn  = '%=%s %=%r '

-- Italic Comments
vim.api.nvim_set_hl(0, 'Comment', { italic })

-- Merge signcolumn and number column into one
vim.o.signcolumn = "yes:2"

-- This variable must be enabled for colors to be applied properly
vim.o.termguicolors = true

-- To prevent conceal
vim.g.indentLine_setConceal = 0 -- Use nvim conceal
vim.o.conceallevel = 2

-- Fold
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99 -- Everthing unfolding

-- Smart indent
vim.opt.smartindent = false

-- For pretty diagnostic
vim.diagnostic.config({ virtual_text = false })
