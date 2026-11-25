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
  { src = 'https://github.com/neovim/nvim-lspconfig' }, -- Default settings of every server
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  -- Debugging (DAP)
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
  -- Undo history, surround
  { src = 'https://github.com/mbbill/undotree' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  -- Markdown rendering in the buffer
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  -- Center the buffer in the window
  { src = 'https://github.com/shortcuts/no-neck-pain.nvim' },
  -- Vimtex
  { src = 'https://github.com/lervag/vimtex.git' },
  -- Treesitter: text objects, sticky context
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  -- Better folds
  { src = 'https://github.com/kevinhwang91/promise-async' },
  { src = 'https://github.com/kevinhwang91/nvim-ufo' },
  -- Replace/exchange with register operators
  { src = 'https://github.com/gbprod/substitute.nvim' },
  -- Git client
  { src = 'https://github.com/NeogitOrg/neogit' },
  -- Breadcrumbs, input/select UI, messages and cmdline
  { src = 'https://github.com/Bekaboo/dropbar.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/folke/noice.nvim' },
  -- Lua LSP for the Neovim API
  { src = 'https://github.com/folke/lazydev.nvim' },
  -- Rust (configures rust-analyzer itself)
  { src = 'https://github.com/mrcjkb/rustaceanvim' },
  -- Rename with live preview
  { src = 'https://github.com/smjonas/inc-rename.nvim' },
})

-- Installed but not loaded at startup: init.lua runs `packadd` right before they are needed
local lazy_specs = {
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
}
vim.pack.add(lazy_specs, { load = false })

-- Update every plugin (opens a confirmation buffer)
vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, {})

-- Remove plugins that are installed but no longer listed above
vim.api.nvim_create_user_command('PackClean', function()
  local keep = {} -- Lazy plugins are inactive until their packadd
  for _, spec in ipairs(lazy_specs) do keep[vim.fn.fnamemodify(spec.src, ':t')] = true end
  local names = {}
  for _, p in ipairs(vim.pack.get()) do
    if not p.active and not keep[p.spec.name] then names[#names + 1] = p.spec.name end
  end
  if #names == 0 then return vim.notify('PackClean: nothing to remove') end
  if vim.fn.confirm('Remove?\n' .. table.concat(names, '\n'), '&Yes\n&No', 2) == 1 then
    vim.pack.del(names)
  end
end, {})
