-- Dev containers
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Requires docker, jq and `npm i -g @devcontainers/cli`
require("devcontainer_cli").setup({
  -- Config cloned and installed inside the container; set this to your own dotfiles
  -- nvim_dotfiles_repo = "https://github.com/<user>/<repo>.git",
  -- nvim_dotfiles_install_command = "cd ~/nvim_dotfiles/ && ./install.sh",
})
