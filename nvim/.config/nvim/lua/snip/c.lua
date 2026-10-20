-- C snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, insert, dynamicn, fn_recur, fn_myself, fn_param = B.ls, B.snip, B.text, B.insert, B.dynamicn, B.fn_recur, B.fn_myself, B.fn_param

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

-- More snippets, written with fmta (<> are the placeholders, << and >> are literal)
do
  local fmta = require("luasnip.extras.fmt").fmta
  local i, rep, ch = B.insert, B.rep, B.choice
  local text = B.text
  local S = B.snip
  local function s(trig, dscr, fmt, nodes)
    return S({ trig = trig, namr = dscr, dscr = dscr }, fmta(fmt, nodes or {}))
  end
  ls.add_snippets("c", {

    s("inc", "Include a system header", [[#include <<<>.h>>
<>]], { i(1, "stdio"), i(0) }),
    s("incl", "Include a local header", [[#include "<>.h"
<>]], { i(1, "header"), i(0) }),
    s("guard", "Header guard", [[#ifndef <>_H
#define <>_H

<>

#endif /* <>_H */]], { i(1, "NAME"), rep(1), i(0), rep(1) }),
    s("struct", "Struct", [[struct <> {
  <>
};]], { i(1, "name"), i(2) }),
    s("typedef", "Typedef struct", [[typedef struct {
  <>
} <>;]], { i(2), i(1, "name_t") }),
    s("switch", "Switch", [[switch (<>) {
  case <>:
    <>
    break;
  default:
    break;
}]], { i(1, "value"), i(2, "X"), i(3) }),
    s("malloc", "malloc with NULL check", [[<> *<> = malloc(<> * sizeof(*<>));
if (<> == NULL) {
  <>
}]], { i(1, "int"), i(2, "ptr"), i(3, "n"), rep(2), rep(2), i(0, "return -1;") }),
    s("fopen", "fopen with check", [[FILE *<> = fopen(<>, "<>");
if (<> == NULL) {
  perror("fopen");
  <>
}]], { i(1, "fp"), i(2, "path"), i(3, "r"), rep(1), i(0, "return -1;") }),
    s("printf", "printf", [[printf("<>\n"<>);]], { i(1), i(2) }),
    s("dbg", "Debug print with file and line", [[fprintf(stderr, "[%s:%d] <> = %<>\n", __FILE__, __LINE__, <>);]], { i(1, "var"), i(2, "d"), rep(1) }),

  })
end

local i, rep = B.insert, B.rep

B.add("c", {
  { "main", "main with args", [[int main(int argc, char **argv) {
    <>
    return 0;
}]], { i(0) } },
  { "inc", "System include", [[#include <<<>.h>>]], { i(1, "stdio") } },
  { "incl", "Local include", [[#include "<>.h"]], { i(1, "file") } },
  { "guard", "Header guard", [[#ifndef <>_H
#define <>_H

<>

#endif /* <>_H */]], { i(1, "NAME"), rep(1), i(0), rep(1) } },
  { "struct", "Typedef struct", [[typedef struct {
    <> <>;
} <>;]], { i(1, "int"), i(2, "field"), i(3, "Name") } },
  { "enum", "Typedef enum", [[typedef enum {
    <>,
} <>;]], { i(1, "VALUE"), i(2, "Name") } },
  { "malloc", "malloc with check", [[<> *<> = malloc(<> * sizeof(*<>));
if (!<>) {
    perror("malloc");
    exit(EXIT_FAILURE);
}]], { i(1, "int"), i(2, "p"), i(3, "n"), rep(2), rep(2) } },
  { "fopen", "fopen with check", [[FILE *<> = fopen(<>, "<>");
if (!<>) {
    perror("fopen");
    return 1;
}
<>
fclose(<>);]], { i(1, "f"), i(2, "path"), i(3, "r"), rep(1), i(0), rep(1) } },
  { "while", "while loop", [[while (<>) {
    <>
}]], { i(1, "cond"), i(0) } },
  { "switch", "switch", [[switch (<>) {
case <>:
    <>
    break;
default:
    break;
}]], { i(1, "x"), i(2), i(0) } },
  { "printf", "printf", [[printf("<>\n"<>);]], { i(1), i(0) } },
})
