-- Set gruvbox as color schema
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.o.background = "dark" -- or light
vim.o.gruvbox_material_better_performance = true
vim.o.gruvbox_material_background = "hard" -- hard/medium/soft

vim.cmd([[colorscheme gruvbox-material]])

vim.cmd([[highlight link NormalFloat Normal]]) -- Float windows same color as normal one

vim.cmd([[highlight SignColumn guibg=NONE]])

