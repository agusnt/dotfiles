-- Sh snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, insert, dynamicn, fn_myself = B.ls, B.snip, B.text, B.insert, B.dynamicn, B.fn_myself

ls.filetype_extend("bash", { "sh" }) -- include all sh snips in bash buffers

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

-- More snippets, written with fmta (<> are the placeholders, << and >> are literal)
do
  local fmta = require("luasnip.extras.fmt").fmta
  local i, rep, ch = B.insert, B.rep, B.choice
  local text = B.text
  local S = B.snip
  local function s(trig, dscr, fmt, nodes)
    return S({ trig = trig, namr = dscr, dscr = dscr }, fmta(fmt, nodes or {}))
  end
  ls.add_snippets("sh", {

    s("shebang", "Bash shebang", [[#!/usr/bin/env bash
<>]], { i(0) }),
    s("strict", "Strict mode", [[set -euo pipefail
<>]], { i(0) }),
    s("usage", "Usage + getopts", [[usage() {
  echo "Usage: $0 [-h] [-<> <>]" >>&2
  exit 1
}

while getopts "h<>:" opt; do
  case "$opt" in
    <>) <>="$OPTARG" ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))
<>]], { i(1, "o"), i(2, "value"), rep(1), rep(1), i(3, "var"), i(0) }),
    s("case", "Case statement", [[case "$<>" in
  <>)
    <>
    ;;
  *)
    <>
    ;;
esac]], { i(1, "var"), i(2, "pattern"), i(3), i(0) }),
    s("func", "Function", [[<>() {
  local <>="$1"
  <>
}]], { i(1, "name"), i(2, "arg"), i(0) }),
    s("trap", "Cleanup trap", [[cleanup() {
  <>
}
trap cleanup EXIT
<>]], { i(1, "rm -f \"$tmp\""), i(0) }),
    s("readl", "Read a file line by line", [[while IFS= read -r <>; do
  <>
done << "<>"]], { i(1, "line"), i(2), i(3, "file") }),
    s("check", "Require a command", [[command -v <> >>/dev/null 2>>&1 || { echo "<> is required" >>&2; exit 1; }]], { i(1, "cmd"), rep(1) }),

  })
end

local i, rep = B.insert, B.rep

B.add("sh", {
  { "strict", "Strict mode", [[set -euo pipefail
IFS=$'\n\t'
]], {} },
  { "fn", "Function", [[<>() {
  local <>="$1"
  <>
}]], { i(1, "name"), i(2, "arg"), i(0) } },
  { "case", "case statement", [[case "$<>" in
  <>)
    <>
    ;;
  *)
    <>
    ;;
esac]], { i(1, "var"), i(2, "pattern"), i(3), i(0) } },
  { "usage", "Usage check", [[if [ $# -lt <> ]; then
  echo "Usage: $0 <>" >>&2
  exit 1
fi]], { i(1, "1"), i(2, "<arg>") } },
  { "trap", "Cleanup trap", [[tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
]], {} },
  { "dir", "Script directory", [[DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"]], {} },
  { "readl", "Read file by lines", [[while IFS= read -r <>; do
  <>
done << "<>"]], { i(1, "line"), i(0), i(2, "file") } },
  { "chk", "Command exists", [[command -v <> >>/dev/null 2>>&1 || { echo "<> not found" >>&2; exit 1; }]], { i(1, "cmd"), rep(1) } },
})
