-- Set the color schema
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local colors = require('gruvbox').palette
require("gruvbox").setup({
  contrast = "hard",
  overrides = {
    SignColumn = { bg = colors.bg0 },
    Folded = { bg = colors.dark0 },
    GruvboxRedSign = { bg = colors.bg0 }
  },
  highlights = {
    fill = {
      bg = colors.bg0,
      guibg = colors.bg0
    }
  }
})

vim.o.background = "dark" -- or light

vim.cmd([[colorscheme gruvbox]])
vim.cmd([[highlight! link StatusLine Normal]])
vim.cmd([[highlight! link StatusLineNC NormalNC]])

-- Fix colors
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = colors.bg0, fg = colors.fg0 })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = colors.bg0 })

-- Gitsigns
vim.api.nvim_set_hl(0, "GitGutterAdd", { bg = colors.bg0 })
vim.api.nvim_set_hl(0, "GitGutterChange", { bg = colors.bg0 })
vim.api.nvim_set_hl(0, "GitGutterDelete", { bg = colors.bg0 })
vim.api.nvim_set_hl(0, "GitGutterChangeDelete", { bg = colors.bg0 })

-- LSP
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.bright_red, bg = colors.bg0 })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = colors.bright_red, bg = colors.bg0 })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = colors.bright_aqua, bg = colors.bg0 })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = colors.bright_purple, bg = colors.bg0 })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = colors.bright_yellow, bg = colors.bg0 })
