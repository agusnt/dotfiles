-- Conform
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Formatters are installed by Mason (config/servers.lua)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    asm = { "asmfmt" },
    cmake = { "cmake_format" },
    dockerfile = { "dockerfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    tex = { "tex-fmt" },
    plaintex = { "tex-fmt" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    json = { "jq" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    bib = { "bibtex-tidy" },
  },
  -- Format on save; filetypes without a formatter use the LSP
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  -- log_level = vim.log.levels.DEBUG,
  quiet = false,
})
