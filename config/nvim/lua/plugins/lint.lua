-- Lintern
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('lint').linters_by_ft = {
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
  bash = { 'shellcheck' },
  -- python = { 'flake8' },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})
