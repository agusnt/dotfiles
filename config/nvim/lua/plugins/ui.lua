-- UI plugins: indent guides, git signs, key hints, marks, TODO comments, colorizer
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Indent guides (pcall: not essential, skip silently if missing)
local status_ok, ibl = pcall(require, "ibl")
if status_ok then
  ibl.setup({
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
  })
end

-- Git hunks in the sign column (preview/blame maps live in config/keymap.lua)
require("gitsigns").setup({})
require("which-key").setup({})
-- Show marks in the sign column
require("marks").setup({})
-- Highlight color codes (#rrggbb, rgb(), names) in the buffer
require("colorizer").setup()

-- Highlight TODO/FIXME/NOTE... tags; the search uses ripgrep
require("todo-comments").setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#EA6962" },
    warning = { "DiagnosticWarn", "WarningMsg", "#D8A657" },
    info = { "DiagnosticInfo", "#A9B665" },
    hint = { "DiagnosticHint", "#7DAEA3" },
    default = { "Identifier", "#E78A4E" },
    test = { "Identifier", "#D3869B" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
})
