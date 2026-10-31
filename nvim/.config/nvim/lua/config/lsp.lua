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
vim.lsp.config('ltex_plus', {
  filetypes = { 'markdown', 'text', 'tex', 'norg' },
  settings = {
    ltex = {
      language = 'auto',
      enabled = { 'markdown', 'latex', 'plaintext', 'norg' },
      additionalRules = { enablePickyRules = false },
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
