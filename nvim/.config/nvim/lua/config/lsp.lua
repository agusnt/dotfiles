-- LSP (Neovim 0.12+)
-- Server defaults (cmd, filetypes, root markers) come from nvim-lspconfig; only the
-- differences are set here. The list of servers is in config/servers.lua.
-- Overrides must be set with vim.lsp.config() (not lsp/<server>.lua in this repo): plugin
-- runtime dirs come after the user config in 'runtimepath' and win over lsp/*.lua files.
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local servers = require('config/servers')

-- lua_ls: only what differs from nvim-lspconfig's defaults
vim.lsp.config('lua_ls', {
  root_markers = { '.luarc.json', '.luarc.jsonc', 'stylua.toml', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
})

vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config('texlab', {
  settings = {
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1' },
        onSave = true,
      },
      forwardSearch = {
        executable = 'zathura',
        args = { '--synctex-forward', '%l:1:%f', '%p' },
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = { command = 'clippy' },
    },
  },
})

-- Grammar and spell checking (the default filetypes would cover every language).
-- ltex-ls-plus replaces harper-ls: harper only knows English, ltex detects the language
-- of each sentence ('auto'). norg is not a ltex filetype, so it is enabled by hand and
-- checked as plain text.
-- ltex asks the client to run its code actions (add to dictionary, hide false positive,
-- disable rule). Neovim has no built-in handler, so the choices are saved to
-- stdpath('data')/ltex/<setting>.<lang>.txt and fed back through the settings.
local ltex_dir = vim.fn.stdpath('data') .. '/ltex'
local ltex_settings = {
  ['_ltex.addToDictionary'] = { key = 'words', setting = 'dictionary' },
  ['_ltex.disableRules'] = { key = 'ruleIds', setting = 'disabledRules' },
  ['_ltex.hideFalsePositives'] = { key = 'falsePositives', setting = 'hiddenFalsePositives' },
}

local function ltex_read(setting, lang)
  local path = ('%s/%s.%s.txt'):format(ltex_dir, setting, lang)
  return vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
end

-- { [lang] = { entries } } for every saved file of a setting
local function ltex_load(setting)
  local result = {}
  for _, path in ipairs(vim.fn.glob(('%s/%s.*.txt'):format(ltex_dir, setting), false, true)) do
    local lang = vim.fn.fnamemodify(path, ':t:r'):sub(#setting + 2)
    result[lang] = vim.fn.readfile(path)
  end
  return result
end

for name, spec in pairs(ltex_settings) do
  vim.lsp.commands[name] = function(command, ctx)
    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local settings = client.settings.ltex
    settings[spec.setting] = settings[spec.setting] or {}
    for lang, entries in pairs(command.arguments[1][spec.key]) do
      local merged = ltex_read(spec.setting, lang)
      for _, entry in ipairs(entries) do
        if not vim.tbl_contains(merged, entry) then
          table.insert(merged, entry)
        end
      end
      vim.fn.mkdir(ltex_dir, 'p')
      vim.fn.writefile(merged, ('%s/%s.%s.txt'):format(ltex_dir, spec.setting, lang))
      settings[spec.setting][lang] = merged
    end
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end
end

vim.lsp.config('ltex_plus', {
  filetypes = { 'markdown', 'text', 'tex', 'norg' },
  settings = {
    ltex = {
      language = 'auto',
      enabled = { 'markdown', 'latex', 'plaintext', 'norg' },
      additionalRules = { enablePickyRules = false },
      dictionary = ltex_load('dictionary'),
      disabledRules = ltex_load('disabledRules'),
      hiddenFalsePositives = ltex_load('hiddenFalsePositives'),
    },
  },
})

-- Servers without an override above run with the nvim-lspconfig defaults

vim.lsp.enable(vim.tbl_keys(servers.lsp))

-- ===== DIAGNOSTICS =====
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057}",
      [vim.diagnostic.severity.WARN] = "\u{f071}",
      [vim.diagnostic.severity.HINT] = "\u{f0eb}",
      [vim.diagnostic.severity.INFO] = "\u{f05a}",
    },
  },
  virtual_text = true,
  jump = {
    on_jump = function(_, bufnr) -- Open the float after [d / ]d
      vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
    end,
  },
  severity_sort = true,
})
