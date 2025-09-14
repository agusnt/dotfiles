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
          tex = { 'latexindent', 'bibtex-tidy' },
          bash = { 'shfmt' },
          json = { 'jq' },
          python = { 'ruff_format' },
        },
        format_on_save = {
          timeout_ms = 500,
        },
        formatters = {
          shfmt = {
            args = {'-i', '2'}
          }
        },
        -- log_level = vim.log.levels.DEBUG,
        quiet = false
      })
    end
  }
}
