--- Mason plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = ""
        }
    }
})

require('mason-tool-installer').setup({
  -- LSP servers
  "lua-language-server", 
  "rust-analyzer",
  "asm-lsp",
  "basedpyright",
  "clangd",
  "texlab",
  "bash-language-server", 
  "neocmakelsp",
  "docker-language-server",
  "json-lsp",
  "awk-language-server",
  "cspell-lsp",
  "harper-ls",
  "marksman",
  -- Formatters
  "asmfmt",
  "autopep8",
  "beautysh",
  "clang-format", 
  "cmakelang",
  "dockerfmt",
  "tex-fmt",
  -- Linters
  "cpplint",
  "cspell",
  -- Debug adapters
  "bash-debug-adapter",
  "cpptools",
  -- Other
  "ast-grep",
  "bibtex-tidy",
})

-- Only LSP servers for mason-lspconfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "asm_lsp",
    "basedpyright",
    "clangd",
    "texlab",
    "bashls",
    "neocmake",
    "harper_ls",
    "dockerls",
    "jsonls",
    "marksman"
  },
  automatic_installation = true,
})
