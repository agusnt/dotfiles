-- vim pack installation
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Must be registered before vim.pack.add so it fires on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data
    if data.kind ~= 'install' and data.kind ~= 'update' then return end
    local name = data.spec.name
    if name == 'LuaSnip' then
      if not data.active then vim.cmd.packadd('LuaSnip') end
      vim.system({ 'make', 'install_jsregexp' }, { cwd = data.path }):wait()
    elseif name == 'telescope-fzy-native.nvim' then
      vim.system({ 'make' }, { cwd = data.path }):wait()
    elseif name == 'blink.cmp' then
      -- Build the Rust fuzzy matcher only when the plugin changes, not on every startup
      if not data.active then vim.cmd.packadd('blink.cmp') end
      -- Needs cargo; without it blink falls back to the Lua matcher
      local ok, err = pcall(function() require('blink.cmp').build():pwait() end)
      if not ok then vim.notify('blink.cmp build failed: ' .. tostring(err), vim.log.levels.WARN) end
    end
  end,
})

vim.pack.add({
  -- CMP plugins
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = "https://github.com/saghen/blink.lib" },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  -- Formatter
  { src = 'https://github.com/stevearc/conform.nvim' },
  -- Lintern
  { src = 'https://github.com/mfussenegger/nvim-lint' },
  -- Lualine
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  -- Telescope
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzy-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim' },
  -- Neorg
  { src = 'https://github.com/nvim-neorg/neorg' },
  { src = 'https://github.com/nvim-neorg/tree-sitter-norg' },
  { src = 'https://github.com/nvim-neorg/tree-sitter-norg-meta' },
  { src = 'https://github.com/nvim-neorg/lua-utils.nvim' },
  { src = 'https://github.com/pysan3/pathlib.nvim' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/3rd/image.nvim' },
  -- Code action
  { src = 'https://github.com/rachartier/tiny-code-action.nvim' },
  -- Colorizer
  { src = 'https://github.com/catgoose/nvim-colorizer.lua' },
  -- TODO comments
  { src = 'https://github.com/folke/todo-comments.nvim' },
  -- Material
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
  -- Leap
  { src = 'https://codeberg.org/andyg/leap.nvim' },
  -- Marks
  { src = 'https://github.com/chentoast/marks.nvim' },
  -- Ident lines
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  -- Treesitter
  { src = 'https://github.com/arborist-ts/arborist.nvim' },
  -- Git signs
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  -- Key hints
  { src = 'https://github.com/folke/which-key.nvim' },
  -- Autopairs
  { src = 'https://github.com/windwp/nvim-autopairs' },
  -- File explorer
  { src = 'https://github.com/stevearc/oil.nvim' },
  -- Common dependencies
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  -- Mason
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' }, -- required by mason-lspconfig
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  -- Debugging (DAP)
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
  -- Tests and tasks
  { src = 'https://github.com/nvim-neotest/neotest' },
  { src = 'https://github.com/nvim-neotest/neotest-python' },
  { src = 'https://github.com/rouge8/neotest-rust' },
  { src = 'https://github.com/stevearc/overseer.nvim' },
  -- Diagnostics list, git diffs, undo history, sessions, surround
  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/mbbill/undotree' },
  { src = 'https://github.com/folke/persistence.nvim' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  -- Dev container (devcontainer CLI)
  { src = 'https://github.com/arnaupv/nvim-devcontainer-cli' },
  -- Markdown rendering in the buffer
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  -- Vimtex
  { src = 'https://github.com/lervag/vimtex.git' },
})
