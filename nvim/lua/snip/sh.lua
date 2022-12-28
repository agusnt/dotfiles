-- Sh snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls.add_snippets("sh", {
    snip({
        trig = "meta",
        namr = "File-metadata",
        dscr = "File metadata",
    }, {
        text({"#", "#", }),
        insert(1, " file description"),
        text({ "", "#", "" }),
        dynamicn(2, fn_myself, {1}, { user_args = { "# " }} ),
        text({"", "#",})
    }),

    snip({
        trig = "div",
        namr = "divider",
        dscr = "divisor",
    }, {
        text({
"#############################################################################",
            "#",}),
        insert(1, " info"),
        text({
            "",
"#############################################################################",
        }),
    }),
})
