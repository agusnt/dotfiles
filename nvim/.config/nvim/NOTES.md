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

`avante.nvim` (heavy, compiles a binary),
`minuet-ai.nvim` (discarded), `windsurf.nvim` (no commits since Apr 2025), `supermaven-nvim`, Ollama as a local backend.

## Added plugins

- `nvim-treesitter-textobjects` (`af if ac ic aa ia ab ib al il`, `]f [f ]a [a`, `<leader>cs/cS` swap) and `nvim-treesitter-context` (`[x`).
- `nvim-ufo` folds (`zR zM zp`), `substitute.nvim` (`<leader>s*` replace, `<leader>e*` exchange; `s`/`S` are Leap).
- `neogit` (`<leader>gg`), `dropbar.nvim` (`<leader>;`), `dressing.nvim`, `noice.nvim` (`<leader>fn` history).
- `lazydev.nvim` (Neovim API for lua_ls + blink source), `inc-rename.nvim` (`<F2>`).
- `rustaceanvim` starts rust-analyzer itself: `rust_analyzer` is not in `config/servers.lua`, only installed by Mason; settings in `vim.g.rustaceanvim` (`config/lsp.lua`).
- `:PackUpdate` updates everything, `:PackClean` removes installed plugins that are no longer in `plugins/pack.lua`.

## Pending / untouched

- Startup: `vim.loader.enable()`, unused built-in plugins off, and `config/lazy.lua` defers most setups until after the first draw (completion also on `InsertEnter`, Neorg on `.norg`/`:Neorg`, Mason tool check 3 s later). LuaSnip and diffview are installed with `load = false` and `packadd`ed by the deferred tasks. Measure with `nvim --startuptime /tmp/s.log`.
- Not verified: real LSP servers (Mason could not install them in the sandbox) and the CodeCompanion chat.
