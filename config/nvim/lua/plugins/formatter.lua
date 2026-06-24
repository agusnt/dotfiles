-- Conform
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Automatic formatter at exit
local home = os.getenv("HOME")
local cwd = vim.fn.getcwd()

require("conform").setup({
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    tex = { 'tex_fmt' },
    plaintex = { 'tex_fmt' },
    bash = { 'shfmt' },
    sh = { 'shfmt' },
    json = { 'jq' },
    python = { 'ruff' },
    rust = { 'rustfmt' },
  },
  format_on_save = {
    timeout_ms = 500,
  },
  formatters = {
    ruff = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/ruff"
      },
    },
    rustfmt = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/rustfmt"
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    jq = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/jq"
      },
    },
    clang_format = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/clang-format"
      },
    },
    shfmt = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/shfmt"
      },
      stdin = true
    },
    tex_fmt = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/tex-fmt"
      },
    },
    bibtex = {
      command = "podman",
      args = {
        "run", "--rm", "-i",
        "-v", home .. ":" .. home .. ":z",
        "-w", cwd,
        "nas.local:5000/bibtex-tidy"
      },
      stdin = "true"
    }
  },
  -- log_level = vim.log.levels.DEBUG,
  quiet = false
})
