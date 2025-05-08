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

    snip({
        trig = "ifempvar",
        namr = "If empty var",
        dscr = "If [ ! -z var ]; then action; fi",
    }, {
        text("if [ ! -z "),
        insert(1, "var"),
        text(" ]; then "),
        insert(2, "action"),
        text("; fi")
    }),

    snip({
        trig = "if",
        namr = "If",
        dscr = "If statement",
    }, {
        text("if [[ "),
        insert(1, "condition"),
        text(" ]]; then "),
        insert(2, "action"),
        text("; fi")
    }),
    snip({
        trig = "for",
        namr = "For",
        dscr = "A for loop",
    }, {
        text("for "),
        insert(1, "var"),
        text(" in "),
        insert(2, "struct"),
        text("; do "),
        insert(3, "action"),
        text("; done"),
    }),

    snip({
        trig = "while",
        namr = "While",
        dscr = "A while loop",
    }, {
        text("while [ "),
        insert(1, "condition"),
        text("]; do "),
        insert(2, "action"),
        text("; done"),
    }),

    snip({
        trig = "fora",
        namr = "forArray",
        dscr = "Iterate over array",
    }, {
        text("for "),
        insert(1, "var"),
        text(" in \"${"),
        insert(2, "array"),
        text("[@]}\"; do "),
        insert(3, "action"),
        text(" done"),
    }),

    snip({
        trig = "forh",
        namr = "forHash",
        dscr = "Iterate over associativity array",
    }, {
        text("for "),
        insert(1, "key"),
        text(" in \"${!"),
        insert(2, "array"),
        text("[@]}\"; do "),
        insert(3, "action"),
        text(" done"),
    }),
})
