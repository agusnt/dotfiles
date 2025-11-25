--- Lazy plugin
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Ensure lazy nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If not install it
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Import the plugins
  },
  install = { colorscheme = { "habamax" } },
  checker = {
    enabled = true,
    notify = false,
    frequency = 3600,
  }, -- Automatic updates
})
