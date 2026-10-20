-- Neorg notes
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Loaded lazily from init.lua on the first .norg buffer
require("neorg").setup({
  load = { -- Neorg modules
    ["core.integrations.image"] = {},
    ["core.latex.renderer"] = {},
    ["core.defaults"] = {},
    ["core.esupports.hop"] = {},
    -- Default keybinds under <leader>n
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = "<Leader>n",
      },
    },
    ["core.concealer"] = {},
    -- Workspaces: :Neorg workspace <name>
    ["core.dirman"] = {
      config = {
        default_workspace = "notes",
        index = "index.norg",
        workspaces = {
          notes = "~/Notes/Notes",
          docencia = "~/Notes/Docencia/",
          research = "~/Notes/Research/",
          sim = "~/Notes/Sim/",
        },
      },
    },
  },
})
