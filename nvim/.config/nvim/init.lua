require('config/vim')         -- Options (sets the leader: must come first)

-- Plugins (pack installs/loads them; the rest configure them)
require('plugins/pack')
require('config/colorschema') -- Colorscheme (needs gruvbox from pack)
require('plugins/ui')
require('plugins/editing')
-- neorg: loaded on the first norg buffer (plugins/neorg)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'norg',
  once = true,
  callback = function() require('plugins/neorg') end,
})
require('plugins/tex')
require('plugins/devcontainer')
require('plugins/tools')
-- pcall: a missing external (tree-sitter CLI) must not abort the rest of the config
local ok, err = pcall(require, 'plugins/treesitter')
if not ok then vim.notify('treesitter: ' .. err, vim.log.levels.WARN) end
require('plugins/lualine')
require('plugins/cmp')
require('plugins/lint')
require('plugins/formatter')
-- telescope: configured on first use (config/keymap.lua)
require('plugins/mason')

-- Snippets, loaded lazily per filetype
require('snip/snip')          -- Luasnips
require('config/autocmds')    -- Autocommands
require('config/keymap')      -- Keymaps
require('config/lsp')         -- LSP
