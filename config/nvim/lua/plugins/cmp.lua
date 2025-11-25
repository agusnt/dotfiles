-- CMP plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'Kaiser-Yang/blink-cmp-dictionary',
      'nvim-lua/plenary.nvim'
    },

    version = 'v1.*',
    opts = {
      keymap = { 
        preset = "none",
        ["<Tab>"] = { "select_next", "fallback", },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback", },
        ["<Enter>"] = { "accept", "fallback", },
        ["<C- >"] = { "show", "hide", },
        ["<C-d>"] = { "show_documentation", "hide_documentation", },
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
    },
    opts_extend = { "sources.default" }
  },
  config = function()
    vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Pmenu" }) 
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
    vim.api.nvim_set_hl(0, "BlinkCmpBorder", { link = "Pmenu" })

    vim.api.nvim_set_hl(0, "BlinkCmpSelected", { link = "PmenuSel" })
  end
}
