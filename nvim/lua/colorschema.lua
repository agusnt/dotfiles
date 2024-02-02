-- Set gruvbox as color schema
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.cmd([[colorscheme gruvbox-material]])

vim.o.background = "dark" -- or light

vim.cmd([[highlight link NormalFloat Normal]]) -- Float windows same color as normal one

vim.cmd([[highlight SignColumn guibg=NONE]])
