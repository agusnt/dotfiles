-- Small tools: surround, git client
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- surround: ys/ds/cs
require("nvim-surround").setup({})

-- Git client (map: <leader>gg); diffs open in Diffview, pickers in Telescope
require("neogit").setup({
  integrations = { diffview = true, telescope = true },
})
