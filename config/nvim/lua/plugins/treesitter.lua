-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("arborist").setup({
  overrides = {
    norg = { url = "https://github.com/nvim-neorg/tree-sitter-norg" },
    norg_meta = { url = "https://github.com/nvim-neorg/tree-sitter-norg-meta" },
  },
  ensure_installed = {
    "norg",
    "norg_meta",
  }
})

