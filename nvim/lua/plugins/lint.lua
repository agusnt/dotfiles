-- Linterns plugins support
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com
--
local lint_server =  {
    'cpplint', 'flake8', 'vale', 'hadolint'
}

-- Lint
require('lint').linters_by_ft = {
    markdown = {'vale',},
    tex = {'vale',},
    c = {'cpplint',},
    cpp = {'cpplint',},
    python = {'flake8',},
    docker = {'hadolint',}
}

-- Linterns
require('mason-nvim-lint').setup({ ensure_installed = lint_server })

-- Formatter
require("formatter").setup()
