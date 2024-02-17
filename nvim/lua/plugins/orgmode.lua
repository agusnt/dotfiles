-- Org-mode plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'},
}

require('orgmode').setup({
  org_agenda_files = {'~/Documents/Org/**/*'},
  org_default_notes_file = '~/Documents/Org/default.org',
})
