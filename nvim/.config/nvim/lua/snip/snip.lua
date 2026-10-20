-- Config snips (loaded lazily: each language module on its first FileType)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- filetype -> snippet module (extensions such as cpp -> c live inside the modules)
local modules = {
  sh = 'sh', bash = 'sh',
  c = 'c', cpp = 'cpp',
  python = 'python', lua = 'lua', rust = 'rust',
  tex = 'tex', plaintex = 'tex',
  html = 'html',
  markdown = 'markdown',
}

local loaded = {}
local function load(name)
  if loaded[name] then return end
  loaded[name] = true
  require('snip/' .. name)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserSnippets', { clear = true }),
  callback = function(ev)
    if not loaded.vscode then
      loaded.vscode = true
      require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
      load('all')
    end
    local mod = modules[ev.match]
    if mod then load(mod) end
  end,
})
