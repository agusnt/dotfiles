-- Lua snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text = B.ls, B.snip, B.text

ls.add_snippets("lua", {
    snip({
        trig = "myself_o",
        namr = "My-Self One line",
        dscr = "Information about myself for one line comments",
    }, {
        text({
                "-- @Author: Navarro Torres, Agustín",
                "-- @Email: agusnavarro11@gmail.com, agusnt@unizar.es"
             }),
    }),
})

local i, rep = B.insert, B.rep

B.add("lua", {
  { "fn", "Function", [[local function <>(<>)
  <>
end]], { i(1, "name"), i(2), i(0) } },
  { "req", "Local require", [[local <> = require("<>")]], { i(1, "mod"), rep(1) } },
  { "for", "Numeric for", [[for <> = <>, <> do
  <>
end]], { i(1, "i"), i(2, "1"), i(3, "n"), i(0) } },
  { "forp", "ipairs loop", [[for <>, <> in ipairs(<>) do
  <>
end]], { i(1, "_"), i(2, "v"), i(3, "list"), i(0) } },
  { "fork", "pairs loop", [[for <>, <> in pairs(<>) do
  <>
end]], { i(1, "k"), i(2, "v"), i(3, "tbl"), i(0) } },
  { "if", "If", [[if <> then
  <>
end]], { i(1, "cond"), i(0) } },
  { "map", "Neovim keymap", [[vim.keymap.set("<>", "<>", <>, { desc = "<>" })]], { i(1, "n"), i(2, "<leader>"), i(3, "rhs"), i(0) } },
  { "au", "Neovim autocmd", [[vim.api.nvim_create_autocmd("<>", {
  callback = function(ev)
    <>
  end,
})]], { i(1, "BufWritePre"), i(0) } },
  { "pcall", "Protected require", [[local ok, <> = pcall(require, "<>")
if not ok then return end
<>]], { i(1, "mod"), rep(1), i(0) } },
})
