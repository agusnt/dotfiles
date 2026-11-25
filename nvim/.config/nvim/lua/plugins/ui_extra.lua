-- UI plugins: indent guides, git signs, key hints, TODO comments, colorizer, noice
-- Loaded after the first draw (see init.lua)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local status_ok, ibl = pcall(require, "ibl")
if status_ok then
  ibl.setup({
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
  })
end

-- Git hunks in the sign column (preview/blame maps live in config/keymap.lua)
require("gitsigns").setup({})
require("which-key").setup({})
require("which-key").add({ -- Names for the <leader> groups
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>d", group = "debug" },
  { "<leader>e", group = "exchange" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>m", group = "markdown" },
  { "<leader>n", group = "neorg" },
  { "<leader>s", group = "substitute" },
  { "<leader>t", group = "terminal" },
})
-- Highlight color codes (#rrggbb, rgb(), names) in the buffer
require("colorizer").setup()

-- Highlight TODO/FIXME/NOTE... tags; the search uses ripgrep
require("todo-comments").setup({
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",
    bg = "BOLD",
  },
  merge_keywords = true,
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#EA6962" },
    warning = { "DiagnosticWarn", "WarningMsg", "#D8A657" },
    info = { "DiagnosticInfo", "#A9B665" },
    hint = { "DiagnosticHint", "#7DAEA3" },
    default = { "Identifier", "#E78A4E" },
    test = { "Identifier", "#D3869B" }
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
})

-- Breadcrumbs (file > symbols) in the winbar (map: <leader>;)
require("dropbar").setup({})

-- Cmdline, search and command completion in a popup centered on the screen;
-- messages in the corner (history: <leader>fn)
local function popup_row(extra) return math.floor(vim.o.lines * 0.35) + extra end
require("noice").setup({
  cmdline = {
    format = { -- One icon per kind of command
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
    },
  },
  views = {
    cmdline_popup = {
      position = { row = popup_row(0), col = "50%" },
      size = { width = 60, height = "auto" },
      border = { style = "rounded", padding = { 0, 1 } },
    },
    popupmenu = { -- Completion list right under the cmdline
      relative = "editor",
      position = { row = popup_row(3), col = "50%" },
      size = { width = 60, height = 10 },
      border = { style = "rounded", padding = { 0, 1 } },
    },
  },
  routes = { -- Hide noise that is not worth a message
    { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
    { filter = { event = "msg_show", kind = "", find = "fewer lines" }, opts = { skip = true } },
    { filter = { event = "msg_show", kind = "", find = "more line" }, opts = { skip = true } },
    { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
    { -- ltex reports "Checking document" progress on every keystroke
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          return vim.tbl_get(message.opts, "progress", "client") == "ltex_plus"
        end,
      },
      opts = { skip = true },
    },
    { filter = { event = "msg_show", min_height = 10 }, view = "split" },
  },
  notify = { view = "mini" }, -- No nvim-notify/snacks: show notifications as small corner messages
  lsp = {
    override = { -- Render LSP docs with Treesitter markdown
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    signature = { enabled = false }, -- blink.cmp already shows the signature
  },
  presets = {
    bottom_search = false,        -- Search goes in the centered popup too
    command_palette = false,      -- Positions are set in views above
    long_message_to_split = true, -- Long messages go to a split
    lsp_doc_border = true,
  },
})

-- Popup borders in the gruvbox yellow (a colorscheme clears them, so reapply)
local function noice_colors()
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#fabd2f" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#fabd2f", bold = true })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#fabd2f" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#83a598" })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#83a598" })
  vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { fg = "#fabd2f" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = noice_colors })
noice_colors()
