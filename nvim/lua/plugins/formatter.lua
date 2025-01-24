-- Conform
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Automatic formatter at exit
return {
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { 'clang-format' },
          cpp = { 'clang-format' },
          asm = { 'asmfmt' },
          tex = { 'latexindent', 'bibtex-tidy' },
          bash = { 'beautysh' },
          html = { 'htmlbeautifier' },
          json = { 'jq' },
          python = { 'autoflake' },
          markdown = { 'markdown-toc' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      })
    end
  }
}
