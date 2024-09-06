-- Import plugins config
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require("plugins/lazy") -- This must be the first one

require("copilot").setup({ suggestion = { enabled = false }, panel = { enabled = false }})
require("copilot_cmp").setup()

require("plugins/mason")
require("plugins/lsp")
require("plugins/dap")
require("plugins/lint")
require("plugins/cmp")
require("plugins/leap")
require("plugins/latex")
require("plugins/indent")
require("plugins/askGemini")
require("plugins/telescope")
require("plugins/treesitter")

-- Now load the plugins that does not need any special configurations
require('Comment').setup()
require('nvim-autopairs').setup()
require('glow').setup()
require('oil').setup()
require('marks').setup()
require('dapui').setup()
