-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Arborist downloads and compiles the parsers (needs the tree-sitter CLI)
require("arborist").setup({
  -- Neorg parsers come from the Neorg org, not the default registry
  overrides = {
    norg = { url = "https://github.com/nvim-neorg/tree-sitter-norg" },
    norg_meta = { url = "https://github.com/nvim-neorg/tree-sitter-norg-meta" },
  },
  -- Parsers installed on startup
  ensure_installed = {
    "norg",
    "norg_meta",
    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
    "c", "cpp", "python", "bash", "rust", "json", "cmake", "dockerfile",
    "regex", -- Highlight of the search cmdline in noice
  },
  concurrency = 4,           -- Parallel parser builds
  install_popular = false,   -- Only install the list above
  disable = { -- LaTeX highlighting is left to VimTeX
    highlight = { "latex", "tex" },
  },
})

-- VimTeX needs the native syntax engine, so drop Treesitter in TeX buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function(ev)
    -- Stop the Treesitter session that Arborist started in this buffer
    vim.treesitter.stop(ev.buf)
    -- Force the native syntax engine that VimTeX relies on
    vim.cmd("syntax on")
  end,
})

-- Text objects (maps in config/keymap.lua); no dependency on nvim-treesitter
require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true }, -- Jump forward to the next match
  move = { set_jumps = true },   -- Add the moves to the jumplist
})

-- Keep the header of the current function/class visible at the top
require("treesitter-context").setup({
  max_lines = 3,
  multiline_threshold = 1,
})
