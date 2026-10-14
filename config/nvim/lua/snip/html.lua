-- HTML snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, insert = B.ls, B.snip, B.text, B.insert

ls.add_snippets("html", {
    snip({
        trig = "film",
        namr = "Film",
        dscr = "A film struct for my website"
    }, {
        text({"<li>", "    <p>", "    <a href=https://www.themoviedb.org/movie/"}),
        insert(2, "id"),
        text({">", "        <p class=\"foo\">"}),
        insert(1, "film"),
        text({"</p></a>", "    <p>", "</li>"}),
    }),

    snip({
        trig = "book",
        namr = "Book",
        dscr = "A book struct for my website"
    }, {
        text({"<li>", "    <p>", "    <a href=https://www.librarything.com/work/"}),
        insert(2, "id"),
        text({">", "        <p class=\"foo\">"}),
        insert(1, "book"),
        text({"</p></a>", "    <p>", "</li>"}),
    }),

})

local i, rep = B.insert, B.rep

B.add("html", {
  { "html5", "HTML5 skeleton", [[<<!DOCTYPE html>>
<<html lang="<>">>
<<head>>
  <<meta charset="UTF-8">>
  <<meta name="viewport" content="width=device-width, initial-scale=1.0">>
  <<title>><><</title>>
<</head>>
<<body>>
  <>
<</body>>
<</html>>]], { i(1, "en"), i(2, "Title"), i(0) } },
  { "link", "Stylesheet link", [[<<link rel="stylesheet" href="<>">>]], { i(1, "style.css") } },
  { "script", "Script tag", [[<<script src="<>">><</script>>]], { i(1, "main.js") } },
  { "a", "Anchor", [[<<a href="<>">><><</a>>]], { i(1, "#"), i(0, "text") } },
  { "img", "Image", [[<<img src="<>" alt="<>">>]], { i(1, "src"), i(2, "alt") } },
  { "ul", "List", [[<<ul>>
  <<li>><><</li>>
<</ul>>]], { i(0) } },
  { "form", "Form", [[<<form action="<>" method="<>">>
  <>
<</form>>]], { i(1), i(2, "post"), i(0) } },
})
