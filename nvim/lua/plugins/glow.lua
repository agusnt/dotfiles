-- Glow 
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('fn')
require('glow').setup({style = "dark", width = 120,})
map("n", "<leader>g", ":Glow<cr>", { silent = true })
