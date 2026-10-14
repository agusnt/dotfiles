-- VimTeX
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- PDF viewer (forward search is also set for texlab in config/lsp.lua)
vim.g.vimtex_view_method = "zathura"
-- Do not re-indent the contents of these environments
vim.g.vimtex_indent_ignored_envs = { 'codebox', 'tcblisting', 'lstlisting', 'verbatim' }
-- Use VimTeX syntax (Treesitter is stopped for TeX in plugins/treesitter.lua)
vim.g.vimtex_syntax_enabled = 1
