-- Leap
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('leap').add_default_mappings()

-- Use x for delete
vim.keymap.del({'x', 'o'}, 'x')
vim.keymap.del({'x', 'o'}, 'X')
