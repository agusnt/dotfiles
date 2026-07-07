-- Conform
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    tex = { "tex-fmt" },
    plaintex = { "tex-fmt" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    json = { "jq" },
    python = { "ruff_format" },
    rust = { "ast-grep" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  -- log_level = vim.log.levels.DEBUG,
  quiet = false,
})
