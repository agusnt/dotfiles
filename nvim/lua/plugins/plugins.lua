-- Import plugins config
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("plugins/lazy") -- This must be the first one
require("plugins/lsp") -- Comment this one if you do not want lsp (saving resources)
require("plugins/leap")
require("plugins/indent")
require("plugins/telescope")
require("plugins/treesitter")
require("plugins/orgmode")

-- Now load the plugins that does not need any special configurations
require('Comment').setup()
require('nvim-autopairs').setup()
require('glow').setup()
require('oil').setup()
