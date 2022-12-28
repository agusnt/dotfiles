-- Config snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls = require("luasnip")
snip = ls.snippet
node = ls.snippet_node
text = ls.text_node
insert = ls.insert_node
func = ls.function_node
choice = ls.choice_node
dynamicn = ls.dynamic_node

-- Load snips for different languages
require('snip/all')
require('snip/sh')
require('snip/c')
require('snip/cpp')
require('snip/python')
require('snip/lua')
