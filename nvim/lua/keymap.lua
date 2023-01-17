-- Movements
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('fn') -- Import auxiliary functions

map("n", "<leader>T", ":enew<CR>", { silent = true }) -- Open a new buffer
map("n", "<leader>l", ":bnext<CR>", { silent = true }) -- Move to the next buffer
map("n", "<leader>h", ":bprevious<CR>", { silent = true }) -- Move to the previous buffer
map("n", "<leader>bq", ":bp <BAR> bd #<CR>", { silent = true }) -- Close the current buffer and move to the previous one

map("n", "<leader>m", ":marks<CR>", { silent = true }) -- Show marks

-- Telescope
map("n", "<leader>ff", ":Telescope file_browser<cr>", { silent = true })
map("n", "<leader>ft", "<cmd>lua require('telescope.builtin').find_files()<cr>", { silent = true })
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { silent = true })
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { silent = true })
map("n", "<leader>fr", ":Telescope<cr>", { silent = true })
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", { silent = true })
map("n", "<leader>fa", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", { silent = true })
map("n", "<leader>fo", "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", { silent = true })

-- LSP
lspmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>') -- Info
lspmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>') -- Goto definition
lspmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>') -- Goto declaration
lspmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>') -- Goto Implementation
lspmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>') -- Goto type definition
lspmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>') -- List references
lspmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>') -- Show arguments
lspmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>') -- Show symbols
lspmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>') -- List options
lspmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
lspmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>') -- Open diagnostic
lspmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
lspmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- Glow
map("n", "<leader>g", ":Glow<cr>", { silent = true })

-- LuaSnip
map("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", {silent = true})
map("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", {silent = true})
map("i", "<c-h>", "<cmd>lua require'luasnip'.jump(-1)<CR>", {silent = true})
map("s", "<c-h>", "<cmd>lua require'luasnip'.jump(-1)<CR>", {silent = true})
map("i", "<c-l>", "<Plug>luasnip-next-choice", {silent = true})
map("s", "<c-l>", "<Plug>luasnip-next-choice", {silent = true})
