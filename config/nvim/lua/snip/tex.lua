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
    trig = "frame",
    namr = "Frame",
    dscr = "Insert a beamer frame",
  }, {
    text("\\begin{frame}{"),
    insert(1),
    text({"}{"}),
    insert(2),
    text({"}", ""}),
    insert(3),
    text({"", "\\end{frame}"}),
  }),
  snip({
    trig = "fragile",
    namr = "Fragile frame",
    dscr = "Insert a beamer fragile frame",
  }, {
    text("\\begin{frame}[fragile]{"),
    insert(1),
    text({"}{"}),
    insert(2),
    text({"}", ""}),
    insert(3),
    text({"", "\\end{frame}"}),
  }),
  snip({
    trig = "itemize",
    namr = "Itemize",
    dscr = "Insert a Itemize block statement",
  }, {
    text({"\\begin{itemize}", ""}),
    insert(1),
    text({"", "\\end{itemize}"}),
  }),
  snip({
    trig = "enumerate",
    namr = "Enumerate",
    dscr = "Insert an enumerate block statement",
  }, {
    text("\\begin{enumerate}", ""),
    insert(1),
    text({"", "\\end{enumerate}"}),
  }),
  snip({
    trig = "block",
    namr = "Block",
    dscr = "Insert a beamer block",
  }, {
    text("\\begin{block}{"),
    insert(1),
    text("}"),
    insert(2),
    text({"", "\\end{block}"}),
  }),
  snip({
    trig = "alertblock",
    namr = "Alert Block",
    dscr = "Insert a beamer alert block",
  }, {
    text("\\begin{alertblock}{"),
    insert(1),
    text("}"),
    insert(2),
    text({"", "\\end{alertblock}"}),
  }),
  snip({
    trig = "exampleblock",
    namr = "Example Block",
    dscr = "Insert a beamer example block",
  }, {
    text("\\begin{exampleblock}{"),
    insert(1),
    text("}"),
    insert(2),
    text({"", "\\end{exampleblock}"}),
  }),

  -- Text format
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
  --  Extra
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
  snip({
    trig = "gra",
    namr = "Graphicx",
    dscr = "Insert a graphicx",
  }, {
    text({"\\includegraphics["}),
    insert(1, "options"),
    text("]{"),
    insert(2, "figure path"),
    text("}"),
  }),
  snip({
    trig = "tab",
    namr = "Table",
    dscr = "Insert a graphicx",
  }, {
    text({"\\begin{table}[]", "\\begin{tabular}{"}),
    insert(1, "cols"),
    text({"}", ""}),
    insert(2),
    text({"\\end{tabular}", "\\end{table}"}),
  })
})
