-- Sh snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com
--

local B = require("snip/base")
local ls, snip, text, insert, dynamicn, rep, fn_recur_3 = B.ls, B.snip, B.text, B.insert, B.dynamicn, B.rep, B.fn_recur_3
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

-- More snippets, written with fmta (<> are the placeholders, << and >> are literal)
do
  local fmta = require("luasnip.extras.fmt").fmta
  local i, rep, ch = B.insert, B.rep, B.choice
  local text = B.text
  local S = B.snip
  local function s(trig, dscr, fmt, nodes)
    return S({ trig = trig, namr = dscr, dscr = dscr }, fmta(fmt, nodes or {}))
  end
  ls.add_snippets("tex", {

    s("sec", "Section with label", [[\section{<>}
\label{sec:<>}
<>]], { i(1, "title"), i(2, "label"), i(0) }),
    s("ssec", "Subsection with label", [[\subsection{<>}
\label{sec:<>}
<>]], { i(1, "title"), i(2, "label"), i(0) }),
    s("sssec", "Subsubsection", [[\subsubsection{<>}
<>]], { i(1, "title"), i(0) }),
    s("eq", "Equation with label", [[\begin{equation}
  <>
  \label{eq:<>}
\end{equation}]], { i(1), i(2, "label") }),
    s("ali", "Align environment", [[\begin{align*}
  <>
\end{align*}]], { i(1) }),
    s("mk", "Inline math", [[$<>$]], { i(1) }),
    s("frac", "Fraction", [[\frac{<>}{<>}]], { i(1, "num"), i(2, "den") }),
    s("sum", "Summation", [[\sum_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "0"), i(3, "n"), i(4) }),
    s("int", "Integral", [[\int_{<>}^{<>} <> \, d<>]], { i(1, "a"), i(2, "b"), i(3, "f(x)"), i(4, "x") }),
    s("lim", "Limit", [[\lim_{<> \to <>} <>]], { i(1, "x"), i(2, "\\infty"), i(3) }),
    s("thm", "Theorem", [[\begin{theorem}
  <>
\end{theorem}]], { i(1) }),
    s("lem", "Lemma", [[\begin{lemma}
  <>
\end{lemma}]], { i(1) }),
    s("def", "Definition", [[\begin{definition}
  <>
\end{definition}]], { i(1) }),
    s("proof", "Proof", [[\begin{proof}
  <>
\end{proof}]], { i(1) }),
    s("cite", "Citation", [[\cite{<>}]], { i(1) }),
    s("ref", "Reference", [[\ref{<>}]], { i(1) }),
    s("cref", "Clever reference", [[\cref{<>}]], { i(1) }),
    s("label", "Label", [[\label{<>}]], { i(1) }),
    s("usep", "Use a package", [[\usepackage<>{<>}]], { i(1, "[options]"), i(2, "package") }),
    s("code", "Listing", [[\begin{lstlisting}[language=<>]
<>
\end{lstlisting}]], { i(1, "C"), i(2) }),

  })
end

local i, rep = B.insert, B.rep

B.add("tex", {
  { "sec", "Section", [[\section{<>}
\label{sec:<>}
<>]], { i(1, "Title"), i(2, "label"), i(0) } },
  { "ssec", "Subsection", [[\subsection{<>}
<>]], { i(1, "Title"), i(0) } },
  { "eq", "Equation", [[\begin{equation}
  \label{eq:<>}
  <>
\end{equation}]], { i(1, "label"), i(0) } },
  { "ali", "Align", [[\begin{align}
  <>
\end{align}]], { i(0) } },
  { "mk", "Inline math", [[$<>$]], { i(1) } },
  { "frac", "Fraction", [[\frac{<>}{<>}]], { i(1), i(2) } },
  { "sum", "Sum", [[\sum_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(0) } },
  { "int", "Integral", [[\int_{<>}^{<>} <> \, d<>]], { i(1, "a"), i(2, "b"), i(3), i(4, "x") } },
  { "ref", "Reference", [[\ref{<>}]], { i(1) } },
  { "cite", "Citation", [[\cite{<>}]], { i(1) } },
  { "pkg", "Use package", [[\usepackage{<>}]], { i(1) } },
  { "cmd", "New command", [[\newcommand{\<>}[<>]{<>}]], { i(1, "name"), i(2, "1"), i(3) } },
  { "thm", "Theorem", [[\begin{theorem}
  <>
\end{theorem}]], { i(0) } },
  { "code", "Listing", [[\begin{lstlisting}[language=<>]
<>
\end{lstlisting}]], { i(1, "C"), i(0) } },
})
