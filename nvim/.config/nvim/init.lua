vim.loader.enable()           -- Cache compiled Lua modules

-- Built-in plugins that are not used (oil replaces netrw)
for _, name in ipairs({ 'gzip', 'tarPlugin', 'zipPlugin', 'tohtml', 'tutor', 'netrwPlugin', 'netrwSettings' }) do
  vim.g['loaded_' .. name] = 1
end

require('config/vim')         -- Options (sets the leader: must come first)

-- Plugins (pack installs/loads them; the rest configure them)
require('plugins/pack')
require('config/colorschema') -- Colorscheme (needs gruvbox from pack)
require('plugins/ui')         -- Centered window (must be ready before the first draw)

-- Mason binaries must be on PATH before any server starts (mason.setup does the same)
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- Everything below that is not needed for the first draw loads right after it
-- (config/lazy.lua), or earlier on the event/command that needs it
local lazy = require('config/lazy')
local function load(name) return function() require('plugins/' .. name) end end

lazy.defer('ui_extra', load('ui_extra'))
if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  load('editing')()           -- `nvim <dir>`: oil must take over the directory buffer at once
else
  lazy.defer('editing', load('editing'))
end

-- neorg: loaded on the first .norg file or :Neorg command (it is the slowest to start)
local neorg_loaded = false
local function load_neorg()
  if neorg_loaded then return end
  neorg_loaded = true
  require('plugins/neorg')
end
vim.api.nvim_create_autocmd('FileType', { pattern = 'norg', once = true, callback = load_neorg })
lazy.command('Neorg', load_neorg)

require('plugins/tex')
lazy.defer('markdown', load('markdown'))
lazy.defer('tools', function()
  vim.cmd.packadd('diffview.nvim') -- Neogit and the <leader>g maps use it
  require('plugins/tools')
end)
-- pcall: a missing external (tree-sitter CLI) must not abort the rest of the config
local ok, err = pcall(require, 'plugins/treesitter')
if not ok then vim.notify('treesitter: ' .. err, vim.log.levels.WARN) end
require('plugins/lualine')
lazy.defer('cmp', function() -- Completion and snippets (LuaSnip is installed but not loaded)
  vim.cmd.packadd('LuaSnip')
  require('plugins/cmp')
  require('snip/snip')        -- Luasnips, loaded lazily per filetype
end, { events = { 'InsertEnter', 'CmdlineEnter' } })
lazy.defer('lint', load('lint'))
lazy.defer('formatter', load('formatter'))
-- telescope: configured on first use (config/keymap.lua)
lazy.defer('mason', load('mason'))

require('config/autocmds')    -- Autocommands
require('config/keymap')      -- Keymaps
lazy.defer('lsp', function() require('config/lsp') end)
