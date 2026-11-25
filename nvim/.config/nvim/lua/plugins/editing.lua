-- Editing plugins: autopairs, file explorer, motions, code actions
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Close brackets and quotes automatically
require("nvim-autopairs").setup({})
-- File explorer as a buffer (opened with "-")
require("oil").setup({ view_options = { show_hidden = true } })
-- Jump anywhere on screen with two characters (maps: gs / gS in config/keymap.lua)
require("leap").setup({})
-- Replace or exchange text with a register (maps: <leader>s / <leader>e in config/keymap.lua)
require("substitute").setup({
  highlight_substituted_text = { enabled = true, timer = 200 },
})
-- Folds: Treesitter first, indentation as a fallback (maps: zR / zM / zp)
require("ufo").setup({
  provider_selector = function() return { "treesitter", "indent" } end,
})
-- Rename with a live preview (map: <F2>)
require("inc_rename").setup({})

-- Code action picker with previews, shown in Telescope (map: gf)
require("tiny-code-action").setup({
  backend = "vim",
  picker = "telescope",
  resolve_timeout = 100,
  notify = {
    enabled = true,
    on_empty = true,
  },
  format_title = nil,
  signs = {
    quickfix = { "", { link = "DiagnosticWarn" } },
    others = { "", { link = "DiagnosticWarn" } },
    refactor = { "", { link = "DiagnosticInfo" } },
    ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
    ["refactor.extract"] = { "", { link = "DiagnosticError" } },
    ["source.organizeImports"] = { "", { link = "DiagnosticWarn" } },
    ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
    ["source"] = { "", { link = "DiagnosticError" } },
    ["rename"] = { "󰑕", { link = "DiagnosticWarn" } },
    ["codeAction"] = { "", { link = "DiagnosticWarn" } },
  },
})
