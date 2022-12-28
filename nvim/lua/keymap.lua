-- Movements
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('fn') -- Import auxiliary functions

-- Open a new buffer
map("n", "<leader>T", ":enew<CR>", { silent = true })
-- Move to the next buffer
map("n", "<leader>l", ":bnext<CR>", { silent = true })
-- Move to the previous buffer
map("n", "<leader>h", ":bprevious<CR>", { silent = true })
-- Close the current buffer and move to the previous one
map("n", "<leader>bq", ":bp <BAR> bd #<CR>", { silent = true })

