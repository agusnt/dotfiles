-- Set the color schema
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.o.background = 'dark'
require('gruvbox').setup({ italic = { comments = true } })

local function links()
  vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'NormalNC' })
  vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#7c6f64', blend = 100 })
end

-- A colorscheme clears the highlights, so reapply after every :colorscheme
vim.api.nvim_create_autocmd('ColorScheme', { callback = links })
links()

vim.cmd.colorscheme('gruvbox')
