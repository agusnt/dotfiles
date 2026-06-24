-- C snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls.add_snippets("c", {
    snip({
        trig = "meta",
        namr = "File-metadata",
        dscr = "File metadata",
    }, {
        text({"/*", "* ",}),
        insert(1, "File Description"),
        text({"","*", "",}),
        dynamicn(2, fn_myself, {1}, { user_args = { "* " }} ),
        text({"", "*/", "",}),
    }),

    snip({

        trig = "fmeta",
        namr = "function-metadata",
        dscr = "Function metadata",
    }, {
        text({"/*", "* ",}),
        insert(1, "function description"),
        dynamicn(2, fn_param, {1}, { user_args = { "*" }} ),
        text({"", "*/"}),
    }),

    snip({
        trig = "fn",
        namr = "Definition of function",
        dscr = "Fill definition of function",
    }, {
        insert(1, "return type"),
        text(" "),
        insert(2, "function name"),
        text("("),
        insert(3, "type variable"),
        dynamicn(4, fn_recur, {3}, {user_args = {"type variable"}}),
        text("):"),
    }),

    snip({

        trig = "for",
        namr = "For",
        dscr = "A simple for (;;;)",
    }, {
        text("for ("),
        insert(1, "var"),
        text("; "),
        insert(2, "condition"),
        text("; "),
        insert(3, "action"),
        text(")"),
    }),

    snip({
        trig = "ternary",
        namr = "Ternary",
        dscr = "A ternary if",
    }, {
        insert(1, "var"),
        text(" = "),
        insert(2, "condition"),
        text(" ? "),
        insert(3, "true"),
        text(" : "),
        insert(4, "false"),
        text(";"),
    }),
})
