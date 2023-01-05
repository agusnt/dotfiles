-- HTML snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

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
})
