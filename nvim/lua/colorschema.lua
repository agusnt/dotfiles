-- Set gruvbox as color schema
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Gruvbox config
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

vim.o.background = "dark" -- or light
vim.cmd([[colorscheme gruvbox]])

vim.cmd([[highlight link NormalFloat Normal]]) -- Float windows same color as normal one

vim.cmd([[highlight SignColumn guibg=NONE]])

