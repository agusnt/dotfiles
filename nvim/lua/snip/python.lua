-- Python snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com
ls.add_snippets("python", {
    snip({

        trig = "meta",
        namr = "File-metadata",
        dscr = "File metadata",
    }, {
        text({"'''", "",}),
        insert(1, "File Description"),
        text({"","", "",}),
        dynamicn(2, fn_myself, {1}, { user_args = { "" }} ),
        text({"", "'''", "",}),
    }),

    snip({
        trig = "fn",
        namr = "Definition of function",
        dscr = "Fill definition of function",
    }, {
        text("def "),
        insert(1, "function name"),
        text("("),
        insert(2, "param"),
        dynamicn(3, fn_recur, {2}, {user_args = {"param"}}),
        text("):"),
    }),

    snip({

        trig = "fmeta",
        namr = "function-metadata",
        dscr = "Function metadata",
    }, {
        text({"'''", "",}),
        insert(1, "function description"),
        dynamicn(2, fn_param, {1}, { user_args = { "" }} ),
        text({"", "'''"}),
    }),

    snip({

        trig = "forzip",
        namr = "For zip",
        dscr = "A simple for i, j in zip(x, y) with unlimited parameters",
    }, {
        text("for "),
        insert(1, "value"),
        dynamicn(2, fn_recur, {1}, { user_args = { "value" }} ),
        text(" in zip("),
        insert(3, "struct"),
        dynamicn(4, fn_recur, {3}, { user_args = { "struct" }} ),
        text("):"),
    }),

    snip({

        trig = "for",
        namr = "For",
        dscr = "A simple For i in x",
    }, {
        text("for "),
        insert(1, "value"),
        text(" in "),
        insert(2, "struct"),
        text("):"),
    }),

    snip({

        trig = "forenum",
        namr = "For Enum",
        dscr = "A simple For i, dx in enumerate(x)",
    }, {
        text("for "),
        insert(1, "index"),
        text(", "),
        insert(2, "value"),
        text(" in enumerate("),
        insert(3, "struct"),
        text("):"),
    }),

    snip({

        trig = "ternary",
        namr = "Ternary",
        dscr = "A ternary operator",
    }, {
        insert(1, "variable"),
        text(" = "),
        insert(2, "value"),
        text(" if "),
        insert(3, "condition"),
        text(" else "),
        insert(4, "value"),
    }),
})
