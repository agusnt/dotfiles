-- Colors
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

return {
  -- Telescope and its extensions
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup()
  end
}
