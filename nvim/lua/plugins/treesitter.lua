-- TreeSitter
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require'nvim-treesitter.configs'.setup {
  -- A list of parser names
  ensure_installed = "all",
  sync_install = false, -- Install sync
  auto_install = true,

  highlight = { enable = true, },

  incremental_selection = {
    enable = true,
    keymaps = {
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
    },
  },

  --indent = { enable = true }, -- Experimental
}
