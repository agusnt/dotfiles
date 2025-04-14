-- Lintern
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        c = { 'cpplint' },
        cpp = { 'cpplint' },
        tex = { 'vale' },
        bash = { 'shellcheck' },
        docker = { 'hadolint' },
        python = { 'flake8' },
        markdown = { 'vale' },
      }
    end
  }
}
