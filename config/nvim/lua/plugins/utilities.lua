-- Utility plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("Comment").setup()

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

require("marks").setup({})

require("leap").setup({})

vim.g.gruvbox_background = 'dark'
vim.g.gruvbox_enable_italic = true
vim.cmd.colorscheme('gruvbox')

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

require("colorizer").setup()

require("tiny-code-action").setup({
  backend = "vim",
  picker = "telescope",
  resolve_timeout = 100,
  notify = {
    enabled = true,
    on_empty = true,
  },
  format_title = nil,
  signs = {
    quickfix = { "", { link = "DiagnosticWarning" } },
    others = { "", { link = "DiagnosticWarning" } },
    refactor = { "", { link = "DiagnosticInfo" } },
    ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
    ["refactor.extract"] = { "", { link = "DiagnosticError" } },
    ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
    ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
    ["source"] = { "", { link = "DiagnosticError" } },
    ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
    ["codeAction"] = { "", { link = "DiagnosticWarning" } },
  },
})

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_enabled = 0
vim.g.vimtex_compiler_latexrun = {
  executable = 'podman',
  options = {
    'run', '--rm',
    '--volume=.:/workspace:z',
    '--workdir=/workspace',
    'localhost/latex-container',
    'latexrun'
  }
}

require("neorg").setup({
  load = {
    ["core.integrations.image"] = {},
    ["core.latex.renderer"] = {},
    ["core.defaults"] = {},
    ["core.esupports.hop"] = {},
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = "<Leader>n",
      },
    },
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        default_workspace = "notes",
        index = "index.norg",
        workspaces = {
          notes = "~/Notes/Notes",
          docencia = "~/Notes/Docencia/",
          research = "~/Notes/Research/",
          sim = "~/Notes/Sim/",
        },
      },
    },
  },
})
