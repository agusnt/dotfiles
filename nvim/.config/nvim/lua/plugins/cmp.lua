-- CMP plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- The binary is built from the PackChanged hook in plugins/pack.lua;
-- to build it by hand: :lua require('blink.cmp').build():pwait()
require('blink.cmp').setup({
  keymap = { -- Own mappings only (no preset)
    preset = "none",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-Space>"] = { "show", "hide" },
    ["<C-d>"] = { "show_documentation", "hide_documentation" },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = {
    -- Nothing preselected; the highlighted item is inserted as you move
    list = { selection = { preselect = false, auto_insert = true } },
    keyword = { range = 'full' },
    ghost_text = { enabled = false },
    documentation = { auto_show = false },
    menu = { border = 'rounded' },
  },
  -- Completion sources, in priority order
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  -- Snippets come from LuaSnip (lua/snip)
  snippets = { preset = 'luasnip' },
  signature = { enabled = true },
  -- Rust matcher when the binary is built, Lua matcher otherwise
  fuzzy = { implementation = "prefer_rust" }
})

-- Make the completion menu use the regular popup-menu colors
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpBorder", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpSelected", { link = "PmenuSel" })
