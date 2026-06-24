-- Telescope
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local telescope = require('telescope')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_next",
        ["<C-j>"] = "move_selection_previous",
      },
    },
    file_ignore_patterns = {
      "node_modules", ".git", "%.jpg", "%.jpeg", "%.png", "%.gif", "%.mp4",
      "%.pdf", "%.o", "%.so", "%.dylib", "%.pyc", "__pycache__",
    },
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = false,
      -- follow = true,
    },
    live_grep = {
      -- additional_args = { "--hidden" },
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      ignore_current_buffer = false,
    },
    help_tags = {
      mappings = {
        i = {
          ["<C-d>"] = "preview_scrolling_down",
          ["<C-u>"] = "preview_scrolling_up",
        },
      },
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
    },
  },
})

local extensions = {
  'fzy_native',
  'live_grep_args',
}

for _, ext in ipairs(extensions) do
  local ok, _ = pcall(telescope.load_extension, ext)
  if not ok then
    vim.notify("Telescope extension '" .. ext .. "' not loaded", vim.log.levels.WARN)
  end
end
