-- Set gruvbox as color schema and other minor changes 
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

vim.cmd([[highlight link NormalFloat Normal]]) -- Float windows same color as normal one

vim.cmd([[highlight CursorLine guibg=#282828 ]]) -- Cursor
