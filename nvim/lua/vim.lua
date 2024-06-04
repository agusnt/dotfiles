-- Syntax, number, limit, encoding, tab, fold, backspace, spell
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.o.syntax    = enable  -- Highlight syntax
vim.g.mapleader = "," -- Change mapleader

-- Vertical line and wrap
vim.bo.textwidth   = 0      -- Maximum width of column
vim.bo.wrapmargin  = 0
vim.wo.wrap        = true
vim.wo.linebreak   = true   -- Breaks by word rather than character
vim.opt.colorcolumn = "80"     -- Change color

-- Tab configuration, space instead of tab, 4-size
vim.opt.expandtab  = true -- True for using spaces instead of tab
vim.opt.tabstop    = 4 
vim.opt.shiftwidth = 4 
vim.g.backspace   = indent,eol,start

-- Encode and spell
vim.o.encoding  = "utf-8"
vim.o.spelllang = "en"
vim.opt.spell = false

-- Number relatives
vim.wo.number = relativenumber
vim.o.nu      = true
vim.o.rnu     = true
vim.wo.statuscolumn = '%=%s %=%r│%T'

-- Highlight cursor line
-- vim.o.cursorline   = true
-- vim.o.cursorcolumn = true

-- Italic Comments
vim.api.nvim_set_hl(0, 'Comment', {italic})

-- Set spell
vim.o.spell = true

-- Merge signcolumn and number column into one
vim.o.signcolumn = "number"

-- This variable must be enabled for colors to be applied properly
vim.o.termguicolors = true

-- To prevent conceal
vim.g.indentLine_setConceal = 0 -- Use nvim conceal
vim.o.conceallevel = 2

-- Fold
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Disable mouse
vim.opt.mouse = nil

-- Smart indent
vim.opt.smartindent = false

-- Python option
-- vim.g.python_recommended_style = false
