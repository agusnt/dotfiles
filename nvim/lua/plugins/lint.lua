-- Lintern
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  {
    'mfussenegger/nvim-lint',
    event = {
      "BufReadPre",
      "BufNewFile",
      "BufWritePost",
    },
    config = function()
      require('lint').linters_by_ft = {
        c = { 'clang-format', },
        cpp = { 'clang-format' },
        bash = { 'shellcheck' },
        python = { 'pyright', },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  }
}
