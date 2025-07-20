-- Treesitter color scheme
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          'c',
          'cpp',
          'asm',
          'lua',
          'html',
          'bash',
          'json',
          'make',
          'ninja',
          'cmake',
          'python',
          'comment',
          'gitignore',
          'gitcommit',
          'git_config',
          'git_rebase',
          'gitattributes',
          'dockerfile',
        },
        sync_install = false, -- Install sync
        auto_install = true,
        highlight = {
          disable = { 'latex', 'bash' }, -- Disabel some of them
          enable = true,
        },
        indent = { enable = true },
      })
    end
  },
}
