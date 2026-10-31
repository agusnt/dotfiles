-- Single source of truth for language servers and external tools.
-- config/lsp.lua configures and enables the servers listed here;
-- plugins/mason.lua installs them together with the tools.
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Language servers: lspconfig name -> Mason package
  lsp = {
    lua_ls = 'lua-language-server',
    bashls = 'bash-language-server',
    clangd = 'clangd',
    basedpyright = 'basedpyright',
    texlab = 'texlab',
    rust_analyzer = 'rust-analyzer',
    asm_lsp = 'asm-lsp',
    neocmake = 'neocmakelsp',
    dockerls = 'dockerfile-language-server',
    jsonls = 'json-lsp',
    ltex_plus = 'ltex-ls-plus',
    marksman = 'marksman',
    yamlls = 'yaml-language-server',
    taplo = 'taplo',
    html = 'html-lsp',
    cssls = 'css-lsp',
  },

  -- Mason packages that are not language servers
  tools = {
    -- Formatters
    'asmfmt',
    'stylua',
    'clang-format',
    'cmakelang',
    'dockerfmt',
    'tex-fmt',
    'shfmt',
    'jq',
    'ruff',
    'prettier',
    -- Linters (ruff above also lints Python)
    'shellcheck',
    'markdownlint',
    'hadolint',
    -- Debug adapters
    'codelldb',
    'debugpy',
    -- Other
    'ast-grep',
    'bibtex-tidy',
  },
}
