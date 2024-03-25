-- Movements
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local keymap = vim.keymap.set

require('fn') -- Import auxiliary functions

Map("n", "<leader>T", ":enew<CR>", { silent = true }) -- Open a new buffer
Map("n", "<leader>l", ":bnext<CR>", { silent = true }) -- Move to the next buffer
Map("n", "<leader>h", ":bprevious<CR>", { silent = true }) -- Move to the previous buffer
Map("n", "<leader>bq", ":bp <BAR> bd #<CR>", { silent = true }) -- Close the current buffer and move to the previous one

-- Telescope
Map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { silent = true })
Map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { silent = true })
Map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { silent = true })
Map("n", "<leader>fr", ":Telescope<cr>", { silent = true })
Map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", { silent = true })
Map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", { silent = true })
Map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", { silent = true })
Map("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", { silent = true })
Map("n", "<leader>fy", ":Telescope neoclip<cr>", { silent = true })
Map("n", "<leader>fu", "<cmd>Telescope undo<cr>")

-- LSP
Lspmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>') -- Info
Lspmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>') -- Goto definition
Lspmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>') -- Goto declaration
Lspmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>') -- Goto Implementation
Lspmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>') -- Goto type definition
Lspmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>') -- List references
Lspmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>') -- Show arguments
Lspmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>') -- Show symbols
Lspmap('n', 'gf', '<cmd>lua vim.lsp.buf.code_action()<cr>') -- List options
Lspmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
Lspmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>') -- Open diagnostic
Lspmap('n', 'gn', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
Lspmap('n', 'gp', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- DAP
Map("n", "dc", "<cmd>lua AskArgs()<CR>", {silent = true})
Map("n", "dn", "<cmd>lua require('dap').step_into()<CR>", {silent = true})
Map("n", "do", "<cmd>lua require('dap').step_over()<CR>", {silent = true})
Map("n", "dO", "<cmd>lua require('dap').step_out()<CR>", {silent = true})
Map("n", "db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", {silent = true})
Map("n", "dB", "<cmd>lua require('dap').set_breakpoint()<CR>", {silent = true})
Map("n", "dx", "<cmd>lua require('dap').set_breakpoint()<CR>", {silent = true})
Map("n", "dy", "<cmd>lua require('dap').repl.open()<CR>", {silent = true})
Map("n", "dl", "<cmd>lua require('dap').run_last()<CR>", {silent = true})
Map("n", "dt", "<cmd>lua require('dap').terminate()<CR>", {silent = true})

-- LuaSnip
Map("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", {silent = true})
Map("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", {silent = true})
Map("i", "<c-h>", "<cmd>lua require'luasnip'.jump(-1)<CR>", {silent = true})
Map("s", "<c-h>", "<cmd>lua require'luasnip'.jump(-1)<CR>", {silent = true})
Map("i", "<c-l>", "<Plug>luasnip-next-choice", {silent = true})
Map("s", "<c-l>", "<Plug>luasnip-next-choice", {silent = true})
