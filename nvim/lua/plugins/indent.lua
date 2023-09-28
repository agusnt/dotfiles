-- Indent lines
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:"

-- Active
vim.cmd [[highlight IndentBlanklineContextChar guifg=#d79921 gui=nocombine]]

-- No active
vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#504945 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineChar guifg=#504945 gui=nocombine]]

require("ibl").setup {
    space_char_blankline = " ",
    show_end_of_line = true,

    show_trailing_blankline_indent = false,
    show_current_context = true,

    use_treesitter = true,
    use_treesitter_scope = true,
}
