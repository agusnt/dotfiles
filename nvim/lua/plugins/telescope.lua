-- Telescope
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Telescope and its extensions 
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-dap.nvim',
  'nvim-telescope/telescope-fzy-native.nvim',
  'nvim-telescope/telescope-live-grep-args.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local telescope = require('telescope')

    -- Load extensions
    telescope.load_extension('dap')
    telescope.load_extension('emoji')
    telescope.load_extension('fzy_native')
    telescope.load_extension('live_grep_args')
  end
}
