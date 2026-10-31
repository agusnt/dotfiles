-- Key mappings
-- The sway cheat sheet (sway/cheatsheet/nvim.sh) parses this file: keep a
-- standalone `-- Title` comment above each group and a trailing
-- `-- description` on the first line of every map()/lmap() call.
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local map = vim.keymap.set
local silent = { silent = true }

-- Buffers
map("n", "<leader>T", "<cmd>enew<CR>", silent)             -- Open a new buffer
map("n", "<leader>l", "<cmd>bnext<CR>", silent)            -- Move to the next buffer
map("n", "<leader>h", "<cmd>bprevious<CR>", silent)        -- Move to the previous buffer
map("n", "]b", "<cmd>bnext<CR>", silent)                   -- Move to the next buffer
map("n", "[b", "<cmd>bprevious<CR>", silent)               -- Move to the previous buffer
map("n", "<leader>bq", function() -- Close the current buffer keeping the window layout
  local cur = vim.api.nvim_get_current_buf()
  for _, win in ipairs(vim.fn.win_findbuf(cur)) do
    vim.api.nvim_win_call(win, function()
      if not pcall(vim.cmd, 'bprevious') or vim.api.nvim_get_current_buf() == cur then
        vim.cmd.enew()
      end
    end)
  end
  pcall(vim.cmd.bdelete, cur)
end, silent)
map("n", "-", "<cmd>Oil<CR>", silent)                      -- Open the parent directory
map("n", "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", silent) -- Toggle the Markdown rendering in this buffer
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", silent) -- Preview the git hunk
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", silent)   -- Git blame of the line

-- Telescope
local function telescope(name) -- Configured on first use (cached by require)
  return function()
    require('plugins/telescope')
    require('telescope.builtin')[name]()
  end
end
map("n", "<leader>ff", telescope('find_files'), silent)                  -- Find files
map("n", "<leader>fg", function() -- Live grep (accepts rg flags, e.g. "term" -g *.lua)
  require('plugins/telescope')
  require('telescope').extensions.live_grep_args.live_grep_args()
end, silent)
map("n", "<leader>fb", telescope('buffers'), silent)                     -- Open buffers
map("n", "<leader>fr", function() require('plugins/telescope'); vim.cmd.Telescope() end, silent) -- All Telescope pickers
map("n", "<leader>fh", telescope('lsp_document_symbols'), silent)        -- Symbols in this file
map("n", "<leader>fa", telescope('lsp_workspace_symbols'), silent)       -- Symbols in the workspace
map("n", "<leader>fo", telescope('lsp_dynamic_workspace_symbols'), silent) -- Search workspace symbols as you type
map("n", "<leader>fm", telescope('marks'), silent)                       -- Marks

-- LSP (buffer-local, defined once a server attaches)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
  callback = function(ev)
    local function lmap(mode, lhs, rhs)
      map(mode, lhs, rhs, { buffer = ev.buf })
    end
    lmap('n', 'K', vim.lsp.buf.hover)                  -- Hover info
    lmap('n', 'gd', vim.lsp.buf.definition)            -- Goto definition
    lmap('n', 'gD', vim.lsp.buf.declaration)           -- Goto declaration
    lmap('n', 'gi', vim.lsp.buf.implementation)        -- Goto implementation
    lmap('n', 'go', vim.lsp.buf.type_definition)       -- Goto type definition
    lmap('n', 'gr', vim.lsp.buf.references)            -- List references
    lmap('n', '<C-k>', vim.lsp.buf.signature_help)     -- Show arguments
    lmap('n', '<F2>', vim.lsp.buf.rename)              -- Rename symbol
    lmap('n', 'gf', function() require('plugins/telescope'); require("tiny-code-action").code_action() end) -- Code action
    lmap('x', '<F4>', vim.lsp.buf.code_action)         -- Code action on the selection
    lmap('n', 'gl', vim.diagnostic.open_float)         -- Open diagnostic
  end,
})

-- Diagnostics and format
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", silent)               -- Workspace diagnostics list
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", silent) -- Buffer diagnostics list
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", silent)                   -- Quickfix list
map("n", "<leader>fd", function() -- Diagnostics in Telescope
  require('plugins/telescope')
  require('telescope.builtin').diagnostics()
end, silent)
map({ "n", "v" }, "<leader>cf", function() -- Format the buffer or selection
  require("conform").format({ async = true, lsp_format = "fallback" })
end, silent)
map("n", "<leader>ch", function() -- Toggle inlay hints
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, silent)

-- Debug
local function dap(fn)
  return function()
    require('plugins/dap')
    fn(require('dap'), require('dapui'))
  end
end
map("n", "<leader>db", dap(function(d) d.toggle_breakpoint() end), silent) -- Toggle breakpoint
map("n", "<leader>dc", dap(function(d) d.continue() end), silent)          -- Start or continue debugging
map("n", "<leader>di", dap(function(d) d.step_into() end), silent)         -- Step into
map("n", "<leader>do", dap(function(d) d.step_over() end), silent)         -- Step over
map("n", "<leader>dO", dap(function(d) d.step_out() end), silent)          -- Step out
map("n", "<leader>dr", dap(function(d) d.repl.toggle() end), silent)       -- Debug REPL
map("n", "<leader>dt", dap(function(d) d.terminate() end), silent)         -- Stop debugging
map("n", "<leader>du", dap(function(_, ui) ui.toggle() end), silent)       -- Debug UI

-- Tests and tasks
local function test(fn)
  return function()
    require('plugins/neotest')
    fn(require('neotest'))
  end
end
map("n", "<leader>rn", test(function(t) t.run.run() end), silent)                    -- Run the nearest test
map("n", "<leader>rf", test(function(t) t.run.run(vim.fn.expand("%")) end), silent)  -- Run the tests of this file
map("n", "<leader>rl", test(function(t) t.run.run_last() end), silent)               -- Run the last test again
map("n", "<leader>rs", test(function(t) t.summary.toggle() end), silent)             -- Test summary
map("n", "<leader>ro", test(function(t) t.output.open({ enter = true }) end), silent) -- Test output
map("n", "<leader>or", "<cmd>OverseerRun<cr>", silent)                              -- Run a task (make, scripts...)
map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", silent)                           -- Task list

-- Git
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", silent)          -- Diff of the working tree
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", silent) -- History of this file
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", silent)         -- Close the diff view

-- Undo, sessions and terminal
map("n", "<leader>U", "<cmd>UndotreeToggle<cr>", silent)                              -- Undo history tree
map("n", "<leader>qs", function() require("persistence").load() end, silent)          -- Restore the session of this directory
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, silent) -- Restore the last session
map("n", "<leader>qd", function() require("persistence").stop() end, silent)          -- Do not save the session on exit
map({ "n", "t" }, "<leader>tt", function() require("config.terminal").toggle() end, silent) -- Floating terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", silent)                                          -- Leave terminal mode

-- Windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", silent)             -- Taller window
map("n", "<C-Down>", "<cmd>resize -2<cr>", silent)           -- Shorter window
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", silent)  -- Narrower window
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", silent) -- Wider window

-- Dev container
map("n", "<leader>cdu", "<cmd>DevcontainerUp<cr>", silent)      -- Up the devcontainer
map("n", "<leader>cdc", "<cmd>DevcontainerConnect<cr>", silent) -- Connect to the devcontainer

-- Neorg
map('n', 'gO', function() require('plugins/neorg'); vim.cmd('Neorg toc') end) -- Table of contents

-- LuaSnip
local function jump(n)
  return function() require('luasnip').jump(n) end
end
map({ "i", "s" }, "<c-j>", jump(1), silent)                      -- Next snippet node
map({ "i", "s" }, "<c-h>", jump(-1), silent)                     -- Previous snippet node
map({ "i", "s" }, "<c-l>", "<Plug>luasnip-next-choice", silent) -- Next snippet choice

-- Leap
map({ 'n', 'o' }, 'gs', function() -- Leap to a remote window and act there
  require('leap.remote').action {
    input = vim.fn.mode(true):match('o') and '' or 'v'
  }
end)
map({ 'n', 'o' }, 'gS', function() -- Leap to a remote window, linewise
  require('leap.remote').action { input = 'V' }
end)
