-- Utility plugins
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

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

require("gitsigns").setup({})
require("which-key").setup({})
require("nvim-autopairs").setup({})
require("oil").setup({ view_options = { show_hidden = true } })

require("marks").setup({})

require("leap").setup({})

vim.o.background = 'dark'
require('gruvbox').setup({ italic = { comments = true } })
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
    quickfix = { "", { link = "DiagnosticWarn" } },
    others = { "", { link = "DiagnosticWarn" } },
    refactor = { "", { link = "DiagnosticInfo" } },
    ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
    ["refactor.extract"] = { "", { link = "DiagnosticError" } },
    ["source.organizeImports"] = { "", { link = "DiagnosticWarn" } },
    ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
    ["source"] = { "", { link = "DiagnosticError" } },
    ["rename"] = { "󰑕", { link = "DiagnosticWarn" } },
    ["codeAction"] = { "", { link = "DiagnosticWarn" } },
  },
})


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

-- AI chat/agents through the Claude Code subscription (ACP).
-- Needs `npm i -g @agentclientprotocol/claude-agent-acp` and
-- CLAUDE_CODE_OAUTH_TOKEN in the environment (generate it with `claude setup-token`).
require("codecompanion").setup({
  interactions = {
    chat = { adapter = "claude_code" },
    inline = { adapter = "claude_code" },
    -- `:CodeCompanionCLI` runs the real `claude` binary in a terminal buffer
    cli = {
      agent = "claude_code",
      agents = {
        claude_code = {
          cmd = "claude",
          args = {},
          description = "Claude Code CLI",
          provider = "terminal",
        },
      },
    },
  },
})

-- Dev containers (requires docker, jq and `npm i -g @devcontainers/cli`)
require("devcontainer_cli").setup({
  -- Config cloned and installed inside the container; set this to your own dotfiles
  -- nvim_dotfiles_repo = "https://github.com/<user>/<repo>.git",
  -- nvim_dotfiles_install_command = "cd ~/nvim_dotfiles/ && ./install.sh",
})

-- VimTeX
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_indent_ignored_envs = { 'codebox', 'tcblisting', 'lstlisting', 'verbatim' }
vim.g.vimtex_syntax_enabled = 1
