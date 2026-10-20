-- Lualine
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Names of the language servers attached to the current buffer
local function lsp_clients()
  local names = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do names[#names + 1] = c.name end
  return #names > 0 and (' ' .. table.concat(names, ',')) or ''
end

-- Register being recorded (macro), empty otherwise
local function recording()
  local r = vim.fn.reg_recording()
  return r ~= '' and ('recording @' .. r) or ''
end

-- Status line: gruvbox theme, no separators between components
require('lualine').setup({
  options = {
    theme = 'gruvbox-material',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = { -- Active window
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { recording, lsp_clients, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = { -- Other windows
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
