-- Sh snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com
--
ls.filetype_extend("plaintex", { "tex" }) -- include all tex snips

ls.add_snippets("tex", {
    snip({
        trig = "begin",
        namr = "Begin",
        dscr = "Insert a begin / end statement",
    }, {
        text("\\begin{"),
        insert(1),
        text({"}", ""}),
        insert(2),
        text({"", "\\end{"}),
        rep(1),
        text("}"),
    }),

    snip({
        trig = "bf",
        namr = "bf",
        dscr = "Insert bold text",
    }, {
        text("\\textbf{"),
        insert(1, "text"),
        text({"}"}),
    }),

    snip({
        trig = "it",
        namr = "it",
        dscr = "Insert italic",
    }, {
        text("\\textit{"),
        insert(1, "text"),
        text({"}"}),
    }),

    snip({
        trig = "und",
        namr = "underline",
        dscr = "Insert underline text",
    }, {
        text("\\underline{"),
        insert(1, "text"),
        text({"}"}),
    }),

    snip({
        trig = "tt",
        namr = "tt",
        dscr = "Insert tt text",
    }, {
        text("\\texttt{"),
        insert(1, "text"),
        text({"}"}),
    }),

    snip({
        trig = "fig",
        namr = "Fig",
        dscr = "Insert a figure",
    }, {
        text("\\begin{figure}["),
        insert(1, "position"),
        text({"]", "\\centering", "\\includegraphics["}),
        insert(2, "options"),
        text("]{"),
        insert(3, "figure path"),
        text({"}", "\\caption{"}),
        insert(4, "caption"),
        text({"}", "\\label{"}),
        insert(5, "label"),
        text({"}", "\\end{figure}"}),
    }),

    snip({
        trig = "item",
        namr = "item",
        dscr = "Insert new items",
    }, {
        text("\\item "),
        insert(1, "txt"),
        dynamicn(2, fn_recur_3, {1}, {user_args = { "\\item ", "txt"}})
    }),


})
