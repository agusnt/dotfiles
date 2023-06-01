-- Import plugins config
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("plugins/lazy") -- This must be the first one
require("plugins/lsp")
require("plugins/leap")
require("plugins/indent")
require("plugins/lualine")
require("plugins/telescope")
require("plugins/treesitter")

-- Now load the plugins that does not need any special configurations
require('Comment').setup()
require('nvim-autopairs').setup()
require('glow').setup()
