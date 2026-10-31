-- Neorg notes
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Loaded from init.lua at startup (:Neorg must exist before any .norg buffer)
require("neorg").setup({
  load = { -- Neorg modules
    ["core.integrations.image"] = {},
    ["core.latex.renderer"] = {},
    ["core.defaults"] = {},
    ["core.esupports.hop"] = {},
    -- Default keybinds under <leader>n
    ["core.keybinds"] = {
      config = {
        default_keybinds = true,
        neorg_leader = "<Leader>n",
      },
    },
    ["core.concealer"] = {},
    -- Workspaces: :Neorg workspace <name>
    ["core.dirman"] = {
      config = {
        default_workspace = "notes",
        index = "index.norg",
        workspaces = {
          notes = "~/Notes/Notes",
          docencia = "~/Notes/Docencia/",
          research = "~/Notes/Research/",
          sim = "~/Notes/Sim/",
          pascual = "~/Notes/Pascual/",
        },
      },
    },
  },
})

-- Spell checking in .norg with automatic language detection (en/es).
-- Neovim has no built-in detection: count common stopwords of each language.
local stopwords = {
  en = { "the", "and", "of", "to", "is", "in", "that", "it", "for", "with", "are", "this", "was", "be", "on" },
  es = { "el", "la", "de", "que", "y", "en", "los", "las", "es", "un", "una", "por", "con", "para", "se", "del" },
}
local sets = {}
for lang, words in pairs(stopwords) do
  sets[lang] = {}
  for _, w in ipairs(words) do sets[lang][w] = true end
end

local function detect(buf)
  local score = { en = 0, es = 0 }
  local lines = vim.api.nvim_buf_get_lines(buf, 0, 300, false)
  for word in table.concat(lines, " "):lower():gmatch("%a+") do
    for lang, set in pairs(sets) do
      if set[word] then score[lang] = score[lang] + 1 end
    end
  end
  if score.en + score.es < 5 then return nil end -- Too little text to decide
  return score.es > score.en and "es" or "en"
end

local function set_spelllang(buf)
  local lang = detect(buf)
  if lang and vim.bo[buf].spelllang ~= lang then vim.bo[buf].spelllang = lang end
end

local spell_group = vim.api.nvim_create_augroup("NorgSpell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = "norg",
  callback = function(ev)
    vim.wo.spell = true
    set_spelllang(ev.buf)
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = spell_group,
      buffer = ev.buf,
      callback = function() set_spelllang(ev.buf) end,
    })
  end,
})
