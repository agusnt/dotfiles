-- Marker config
-- @Author: Navarro Torres, Agustín
-- @Email: email

require('marks').setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  sign_priority = { lower=100, upper=100, builtin=100, bookmark=100 }, -- Always max priority to be over lsp
}
