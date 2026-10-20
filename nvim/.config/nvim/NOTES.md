# Configuration notes (Neovim 0.12)

## Deprecation cleanup

Tested with Neovim 0.12.0: `:checkhealth vim.deprecated` reports no warnings.

- `config/lsp.lua`: added `vim.lsp.enable(...)` (servers were never being enabled), removed `on_attach`, `asm-lsp` → `asm_lsp`, signs via `vim.diagnostic.config`.
- `config/keymap.lua`: `vim.keymap.set` with functions; LSP maps in `LspAttach`; `vim.diagnostic.jump` instead of `goto_prev/next`; `code_action` instead of `range_code_action`.
- `config/vim.lua`: removed assignments to nonexistent variables and `nvim-treesitter` leftovers.
- `plugins/pack.lua`: the LuaSnip `PackChanged` autocmd is registered **before** `vim.pack.add`.
- `plugins/formatter.lua`: `lsp_format = "fallback"`; Rust uses `rustfmt`.
- `plugins/mason.lua`: no `automatic_installation`; `dockerfile-language-server`.
- `nvim-colorizer.lua` → maintained fork `catgoose/nvim-colorizer.lua`.
- Removed maps for plugins that are not installed (`NvimTree`, `neoclip`, `undo`).

To change the `src` of an already installed plugin: `vim.pack` uses the one in the lockfile, so run
`:lua vim.pack.del({'name'})`, delete its entry from `nvim-pack-lock.json` and restart.

## LSP

Each server's defaults (cmd, filetypes, root) come from `nvim-lspconfig`; only the differences live in
`vim.lsp.config(...)` calls in `config/lsp.lua` (not `lsp/<server>.lua`: plugin runtime dirs come later
in `runtimepath` and override files in the config dir). `config/servers.lua` lists which servers are enabled and installed.

## External requirements

- `tree-sitter` CLI (Arborist compiles the parsers; without it a warning is shown and the rest of the config still loads).
- `git`, a compiler (`gcc`), `make`.
- Optional for CodeCompanion: `rg`, `file`, `sqlite3`.

## Dev containers — `arnaupv/nvim-devcontainer-cli`

- Replaces `esensar/nvim-dev-container` (it raised a `vim.validate` warning).
- Host: Debian/Ubuntu, `docker`, `jq`, `npm i -g @devcontainers/cli`.
- Commands: `:DevcontainerUp` (`<leader>cdu`), `:DevcontainerConnect` (`<leader>cdc`).
- Installs nvim **inside** the container. By default it clones the LazyVim starter; to use this
  config, uncomment `nvim_dotfiles_repo` and `nvim_dotfiles_install_command` in `plugins/utilities.lua`.
- Inside the container you need `git`, a compiler and the `tree-sitter` CLI.

## AI

### Agents / chat — `olimorris/codecompanion.nvim`

Uses the Claude Code subscription through ACP (`claude_code` adapter), no API key.

1. `npm i -g @agentclientprotocol/claude-agent-acp`
2. `claude setup-token`
3. Export `CLAUDE_CODE_OAUTH_TOKEN` before opening nvim.

| Map | Action |
|---|---|
| `<leader>aa` | Toggle chat |
| `<leader>ap` | Action menu |
| `<leader>ae` (visual) | Send selection to chat |

It is multi-provider: the adapter can be switched (Anthropic, OpenAI, Gemini, Ollama, Copilot...)
without depending on `claudecode.nvim`.

### Inline completion — GitHub Copilot (native, no plugin)

Replaces `minuet-ai.nvim` (which required `ANTHROPIC_API_KEY`, not included in the Claude Code subscription).
Uses Neovim 0.12's `vim.lsp.inline_completion` with `copilot-language-server` (installed by Mason).

- Requires a GitHub account with Copilot (there is a free plan). First time: `:LspCopilotSignIn`.
- Maps (insert): `<A-l>` accept, `<A-]>` / `<A-[>` next/previous suggestion.
- Config in `config/lsp.lua` (`copilot` server) and `config/keymap.lua`.

### Other options considered

`claudecode.nvim` (coupled to Claude Code), `avante.nvim` (heavy, compiles a binary),
`minuet-ai.nvim` (discarded), `windsurf.nvim` (no commits since Apr 2025), `supermaven-nvim`, Ollama as a local backend.

## Pending / untouched

- Lazy loading of plugins (Neorg, CodeCompanion...): not done, measure first with `nvim --startuptime`.
- Not verified: real LSP servers (Mason could not install them in the sandbox) and the CodeCompanion chat.
