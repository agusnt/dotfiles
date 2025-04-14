-- LSP configuration for nvim 0.11
--
-- List of server:
--    * pyright
--    * vscode-html-languageserver
--    * vscode-json-languageserver
--    * ltex-ls
--    * asm-lsp
--    * bash-language-server

-- Configuration of LSP servers
-- Python
vim.lsp.config['pyright'] = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { 'python' },
}

-- C/C++
vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
}

-- HTML
vim.lsp.config['html'] = {
  cmd = { 'vscode-html-languageserver' },
  filetypes = { 'html' },
}

-- JSON
vim.lsp.config['json'] = {
  cmd = { 'vscode-json-languageserver' },
  filetypes = { 'json' },
}

-- Latex
vim.lsp.config['latex'] = {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'markdown', 'bib', 'hmtl' },
}

-- ASM
vim.lsp.config['asm'] = {
  cmd = { 'asm-lsp' },
  filetypes = { 'asm' },
}

-- Bash
vim.lsp.config['bash'] = {
  cmd = { 'bash-language-server' },
  filetypes = { 'sh' },
}

-- LTeX
vim.lsp.config['ltex'] = {
  cmd = { '/opt/ltex-ls-plus-18.5.1/bin/ltex-ls-plus' },
}

vim.api.nvim_create_autocmd(
  {
    "BufNewFile",
    "BufRead",
  },
  {
    pattern = "*.tex",
    callback = function()
      vim.opt.filetype = "tex"
    end
  }
)

-- Enable LSP
vim.lsp.enable({ 'pyright', 'clangd', 'html', 'latex', 'asm', 'ltex' })

-- Pretty diagnostics
local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config {
  float = { border = _border }
}
