-- Tests (loaded on first use from config/keymap.lua)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- One adapter per language; add more here
require('neotest').setup({
  adapters = {
    require('neotest-python'),
    require('neotest-rust'), -- needs cargo-nextest
  },
})
