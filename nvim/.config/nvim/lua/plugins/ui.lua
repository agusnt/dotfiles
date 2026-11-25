-- Window layout: center the text (needs to be ready before the first draw)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Center the text in the window on startup (:NoNeckPain toggles it)
local nnp_ok, nnp = pcall(require, "no-neck-pain")
if nnp_ok then
  nnp.setup({
    width = 150,
    autocmds = { enableOnVimEnter = true },
  })
end
