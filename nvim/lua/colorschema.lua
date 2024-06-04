-- Set the color schema 
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local colors = require('gruvbox').palette
require("gruvbox").setup({
    contrast = "hard",
    overrides = {
            SignColumn = { bg = colors.bg0 },
            Folded = { bg = colors.dark0 },
            GruvboxRedSign = { bg = colors.bg0 }
    },
    highlights = {
        fill = {
            bg = colors.bg0,
        }
    }
})

vim.o.background = "dark" -- or light

vim.cmd([[colorscheme gruvbox]])

vim.api.nvim_set_hl(0, 'FloatBorder', {bg=colors.bg0, fg=colors.fg0})
vim.api.nvim_set_hl(0, 'NormalFloat', {bg=colors.bg0})
vim.api.nvim_set_hl(0, 'CursorLine', {bg=colors.bg2})
