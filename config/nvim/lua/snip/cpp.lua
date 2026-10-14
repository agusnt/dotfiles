-- CPP snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, insert = B.ls, B.snip, B.text, B.insert

ls.filetype_extend("cpp", { "c" }) -- include all C snips

ls.add_snippets("cpp", {
    snip({

        trig = "foreach",
        namr = "ForEach",
        dscr = "A simple for (auto : struct)"
    }, {
        text("for (auto "),
        insert(1, "var"),
        text(": "),
        insert(2, "struct"),
        text(")"),
    }),

    snip({

        trig = "stdout",
        namr = "STDOUT",
        dscr = "Print content to stdout with new line"
    }, {
        text("std::cout << "),
        insert(1, "value"),
        text(" << std::endl;"),
    }),

    snip({

        trig = "stderr",
        namr = "STDERR",
        dscr = "Print content to stderr with new line"
    }, {
        text("std::cerr << "),
        insert(1, "value"),
        text(" << std::endl;"),
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
  ls.add_snippets("cpp", {

    s("class", "Class", [[class <> {
public:
  <>();
  ~<>();

private:
  <>
};]], { i(1, "Name"), rep(1), rep(1), i(0) }),
    s("tmpl", "Template", [[template <<typename <>>>
<>]], { i(1, "T"), i(0) }),
    s("lambda", "Lambda", [=[[<>](<>) {
  <>
}]=], { i(1, "&"), i(2), i(0) }),
    s("uptr", "unique_ptr with make_unique", [[auto <> = std::make_unique<<<>>>(<>);]], { i(1, "ptr"), i(2, "T"), i(3) }),
    s("sptr", "shared_ptr with make_shared", [[auto <> = std::make_shared<<<>>>(<>);]], { i(1, "ptr"), i(2, "T"), i(3) }),
    s("ns", "Namespace", [[namespace <> {
<>
} // namespace <>]], { i(1, "name"), i(0), rep(1) }),
    s("ctor", "Constructor", [[<>::<>(<>) : <> {
  <>
}]], { i(1, "Class"), rep(1), i(2), i(3), i(0) }),
    s("dtor", "Destructor", [[<>::~<>() {
  <>
}]], { i(1, "Class"), rep(1), i(0) }),

  })
end

local i, rep = B.insert, B.rep

B.add("cpp", {
  { "main", "main", [[int main(int argc, char **argv) {
    <>
    return 0;
}]], { i(0) } },
  { "cls", "Class", [[class <> {
public:
    <>() = default;
    ~<>() = default;

private:
    <>
};]], { i(1, "Name"), rep(1), rep(1), i(0) } },
  { "uptr", "unique_ptr", [[auto <> = std::make_unique<<<>>>(<>);]], { i(1, "p"), i(2, "T"), i(0) } },
  { "sptr", "shared_ptr", [[auto <> = std::make_shared<<<>>>(<>);]], { i(1, "p"), i(2, "T"), i(0) } },
  { "lambda", "Lambda", [[[<>](<>) {
    <>
}]], { i(1, "&"), i(2), i(0) } },
  { "vec", "std::vector", [[std::vector<<<>>> <>;]], { i(1, "int"), i(2, "v") } },
  { "map", "std::unordered_map", [[std::unordered_map<<<>, <>>> <>;]], { i(1, "std::string"), i(2, "int"), i(3, "m") } },
  { "ns", "Namespace", [[namespace <> {

<>

} // namespace <>]], { i(1, "name"), i(0), rep(1) } },
  { "tmpl", "Template", [[template <<typename <>>>
<>]], { i(1, "T"), i(0) } },
  { "cout", "std::cout", [[std::cout << <> << '\n';]], { i(0) } },
})
