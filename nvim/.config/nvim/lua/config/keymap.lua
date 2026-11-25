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
map("n", "<leader>;", function() require('dropbar.api').pick() end, silent) -- Pick a breadcrumb (file / symbol)
map("n", "<leader>fn", "<cmd>Noice<CR>", silent)                  -- Message history
map("n", "[x", function() require('treesitter-context').go_to_context(vim.v.count1) end, silent) -- Jump to the context (function header)

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
    local function lmap(mode, lhs, rhs, opts)
      map(mode, lhs, rhs, vim.tbl_extend('force', { buffer = ev.buf }, opts or {}))
    end
    lmap('n', 'K', vim.lsp.buf.hover)                  -- Hover info
    lmap('n', 'gd', vim.lsp.buf.definition)            -- Goto definition
    lmap('n', 'gD', vim.lsp.buf.declaration)           -- Goto declaration
    lmap('n', 'gi', vim.lsp.buf.implementation)        -- Goto implementation
    lmap('n', 'go', vim.lsp.buf.type_definition)       -- Goto type definition
    lmap('n', 'gr', vim.lsp.buf.references)            -- List references
    lmap('n', '<C-k>', vim.lsp.buf.signature_help)     -- Show arguments
    lmap('n', '<F2>', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, { expr = true }) -- Rename symbol with live preview
    lmap('n', 'gf', function() require('plugins/telescope'); require("tiny-code-action").code_action() end) -- Code action
    lmap('x', '<F4>', vim.lsp.buf.code_action)         -- Code action on the selection
    lmap('n', 'gl', vim.diagnostic.open_float)         -- Open diagnostic
  end,
})

-- Diagnostics and format
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

-- Git
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", silent)          -- Diff of the working tree
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", silent) -- History of this file
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", silent)         -- Close the diff view
map("n", "<leader>gg", "<cmd>Neogit<cr>", silent)                -- Git client (status, commit, push)

-- Undo and terminal
map("n", "<leader>U", "<cmd>UndotreeToggle<cr>", silent)                              -- Undo history tree
map({ "n", "t" }, "<leader>tt", function() require("config.terminal").toggle() end, silent) -- Floating terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", silent)                                          -- Leave terminal mode

-- Windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", silent)             -- Taller window
map("n", "<C-Down>", "<cmd>resize -2<cr>", silent)           -- Shorter window
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", silent)  -- Narrower window
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", silent) -- Wider window

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
map({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')                       -- Leap to a character pair in the window
map('n', 'S', '<Plug>(leap-from-window)')                          -- Leap to a character pair in another window
map({ 'n', 'o' }, 'gs', function() -- Leap to a remote window and act there
  require('leap.remote').action {
    input = vim.fn.mode(true):match('o') and '' or 'v'
  }
end)
map({ 'n', 'o' }, 'gS', function() -- Leap to a remote window, linewise
  require('leap.remote').action { input = 'V' }
end)

-- Treesitter text objects
local function select_to(query) -- Select a text object (af, if, aa...)
  return function() require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects') end
end
map({ 'x', 'o' }, 'af', select_to('@function.outer'))  -- Around function
map({ 'x', 'o' }, 'if', select_to('@function.inner'))  -- Inside function
map({ 'x', 'o' }, 'ac', select_to('@class.outer'))     -- Around class
map({ 'x', 'o' }, 'ic', select_to('@class.inner'))     -- Inside class
map({ 'x', 'o' }, 'aa', select_to('@parameter.outer')) -- Around argument
map({ 'x', 'o' }, 'ia', select_to('@parameter.inner')) -- Inside argument
map({ 'x', 'o' }, 'ab', select_to('@block.outer'))     -- Around block
map({ 'x', 'o' }, 'ib', select_to('@block.inner'))     -- Inside block
map({ 'x', 'o' }, 'al', select_to('@loop.outer'))      -- Around loop
map({ 'x', 'o' }, 'il', select_to('@loop.inner'))      -- Inside loop

-- Treesitter moves and swaps
local function move_to(dir, query) -- Move to the next/previous text object
  return function() require('nvim-treesitter-textobjects.move')[dir](query, 'textobjects') end
end
map({ 'n', 'x', 'o' }, ']f', move_to('goto_next_start', '@function.outer'))     -- Next function
map({ 'n', 'x', 'o' }, '[f', move_to('goto_previous_start', '@function.outer')) -- Previous function
map({ 'n', 'x', 'o' }, ']a', move_to('goto_next_start', '@parameter.inner'))    -- Next argument
map({ 'n', 'x', 'o' }, '[a', move_to('goto_previous_start', '@parameter.inner')) -- Previous argument
map("n", "<leader>cs", function() require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner') end, silent) -- Swap argument with the next
map("n", "<leader>cS", function() require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner') end, silent) -- Swap argument with the previous

-- Folds (nvim-ufo)
map("n", "zR", function() require('ufo').openAllFolds() end)   -- Open all folds
map("n", "zM", function() require('ufo').closeAllFolds() end)  -- Close all folds
map("n", "zp", function() require('ufo').peekFoldedLinesUnderCursor() end) -- Peek the folded lines

-- Substitute and exchange
map("n", "<leader>s", function() require('substitute').operator() end, silent)  -- Replace a motion with the register
map("n", "<leader>ss", function() require('substitute').line() end, silent)     -- Replace the line with the register
map("n", "<leader>S", function() require('substitute').eol() end, silent)       -- Replace to the end of line with the register
map("x", "<leader>s", function() require('substitute').visual() end, silent)    -- Replace the selection with the register
map("n", "<leader>e", function() require('substitute.exchange').operator() end, silent) -- Exchange a motion with the next one
map("n", "<leader>ee", function() require('substitute.exchange').line() end, silent)    -- Exchange the line with the next one
map("x", "<leader>e", function() require('substitute.exchange').visual() end, silent)   -- Exchange the selection with the next one
map("n", "<leader>ec", function() require('substitute.exchange').cancel() end, silent)  -- Cancel the pending exchange
