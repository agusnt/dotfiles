-- CMP plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name == 'LuaSnip' then
            if not ev.data.active then vim.cmd.packadd('LuaSnip') end
              vim.fn.system('make install_jsregexp ' .. ev.data.path)
        end
    end,
})

require('blink.cmp').build():pwait()
require('blink.cmp').setup({
  keymap = {
    preset = "none",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Enter>"] = { "accept", "fallback" },
    ["<C- >"] = { "show", "hide" },
    ["<C-d>"] = { "show_documentation", "hide_documentation" },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    keyword = { range = 'full' },
    ghost_text = { enabled = true },
    documentation = { auto_show = false },
    menu = { border = 'rounded' },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'dictionary', 'buffer' },
    providers = {
      dictionary = {
        module = 'blink-cmp-dictionary',
        name = 'Dict',
        min_keyword_length = 3,
      }
    },
  },
  snippets = { preset = 'luasnip' },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust_with_warning" }
})

vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpBorder", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "BlinkCmpSelected", { link = "PmenuSel" })
