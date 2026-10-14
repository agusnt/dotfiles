-- Python snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, insert, dynamicn, fn_recur, fn_myself, fn_param = B.ls, B.snip, B.text, B.insert, B.dynamicn, B.fn_recur, B.fn_myself, B.fn_param

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
        text(":"),
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

    snip({
        trig = "main",
        namr = "Main",
        dscr = "Main define",
    }, {
        text("if __name__ == \"__main__\":")
    }),

    snip({
        trig = "loopfile",
        namr = "Read file",
        dscr = "Loop to read file",
    }, {
        text("with open("),
        insert(1, "file"),
        text(") as "),
        insert(2, "var"),
        text(":")
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
  ls.add_snippets("python", {

    s("class", "Class", [[class <>:
    def __init__(self<>):
        <>]], { i(1, "Name"), i(2), i(0, "pass") }),
    s("dc", "Dataclass", [[@dataclass
class <>:
    <>: <>]], { i(1, "Name"), i(2, "field"), i(0, "int") }),
    s("try", "try / except", [[try:
    <>
except <> as e:
    <>]], { i(1), i(2, "Exception"), i(0, "raise") }),
    s("with", "with statement", [[with <> as <>:
    <>]], { i(1, "ctx"), i(2, "var"), i(0) }),
    s("lc", "List comprehension", [=[[<> for <> in <>]]=], { i(1, "x"), rep(1), i(2, "items") }),
    s("dcomp", "Dict comprehension", [[{<>: <> for <>, <> in <>.items()}]], { i(1, "k"), i(2, "v"), rep(1), rep(2), i(3, "d") }),
    s("argp", "argparse boilerplate", [[parser = argparse.ArgumentParser(description="<>")
parser.add_argument("<>", help="<>")
args = parser.parse_args()
<>]], { i(1), i(2, "name"), i(3), i(0) }),
    s("test", "pytest test", [[def test_<>():
    <>
    assert <>]], { i(1, "name"), i(2), i(0) }),
    s("typ", "Protocol", [[class <>(Protocol):
    def <>(self<>) ->> <>: ...]], { i(1, "Name"), i(2, "method"), i(3), i(0, "None") }),
    s("log", "logging setup", [[import logging

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.<>)
<>]], { i(1, "INFO"), i(0) }),
    s("pathl", "pathlib Path", [[<> = Path(<>)
<>]], { i(1, "path"), i(2, '"."'), i(0) }),

  })
end

local i, rep = B.insert, B.rep

B.add("python", {
  { "cls", "Class", [[class <>:
    def __init__(self, <>):
        <>
]], { i(1, "Name"), i(2), i(0, "pass") } },
  { "dc", "Dataclass", [[from dataclasses import dataclass


@dataclass
class <>:
    <>: <>
]], { i(1, "Name"), i(2, "field"), i(3, "int") } },
  { "with", "with open", [[with open(<>, "<>") as <>:
    <>]], { i(1, "path"), i(2, "r"), i(3, "f"), i(0) } },
  { "try", "try / except", [[try:
    <>
except <> as e:
    <>]], { i(1), i(2, "Exception"), i(0, "raise") } },
  { "argp", "argparse skeleton", [[import argparse


def main():
    parser = argparse.ArgumentParser(description="<>")
    parser.add_argument("<>", help="<>")
    args = parser.parse_args()
    <>


if __name__ == "__main__":
    main()
]], { i(1), i(2, "input"), i(3), i(0) } },
  { "lc", "List comprehension", [=[[<> for <> in <>]]=], { i(1, "x"), rep(1), i(2, "items") } },
  { "ifmain", "Entry point guard", [[if __name__ == "__main__":
    <>]], { i(0, "main()") } },
  { "log", "Logger", [[import logging

log = logging.getLogger(__name__)
]], {} },
  { "test", "pytest test", [[def test_<>():
    <>
    assert <>]], { i(1, "name"), i(2), i(0) } },
})
