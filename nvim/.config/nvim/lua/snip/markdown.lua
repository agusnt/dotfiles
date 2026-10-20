-- Markdown snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")

local i, rep = B.insert, B.rep

B.add("markdown", {
  { "link", "Link", [=[[<>](<>)]=], { i(1, "text"), i(2, "url") } },
  { "img", "Image", [=[![<>](<>)]=], { i(1, "alt"), i(2, "path") } },
  { "code", "Code block", [[```<>
<>
```]], { i(1, "lua"), i(0) } },
  { "task", "Task list", [[- [ ] <>
- [ ] <>]], { i(1), i(0) } },
  { "table", "Table", [[| <> | <> |
| --- | --- |
| <> | <> |]], { i(1, "A"), i(2, "B"), i(3), i(0) } },
  { "front", "Front matter", [[---
title: <>
date: <>
---
]], { i(1), i(2, os.date("%Y-%m-%d")) } },
  { "details", "Collapsible section", [[<<details>>
<<summary>><><</summary>>

<>

<</details>>]], { i(1, "Summary"), i(0) } },
})
