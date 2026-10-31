-- Markdown rendering inside the buffer (needs the markdown treesitter parsers)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('render-markdown').setup({
  file_types = { 'markdown' },
})
