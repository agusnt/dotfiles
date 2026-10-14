-- Lintern
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('lint').linters_by_ft = {
  -- C/C++: clang-tidy already runs inside clangd (--clang-tidy)
  bash = { 'shellcheck' },
  sh = { 'shellcheck' },
  python = { 'ruff' },
  markdown = { 'markdownlint' },
  dockerfile = { 'hadolint' },
}

-- Lint when a buffer is opened and after each save
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})
