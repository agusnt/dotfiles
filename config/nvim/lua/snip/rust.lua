-- Rust snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls = B.ls
local fmta = require("luasnip.extras.fmt").fmta
local i, rep = B.insert, B.rep

-- fmta: <> are the placeholders, << and >> are literal angle brackets
local function s(trig, dscr, fmt, nodes)
  return B.snip({ trig = trig, namr = dscr, dscr = dscr }, fmta(fmt, nodes or {}))
end

ls.add_snippets("rust", {
  s("fn", "Function", [[fn <>(<>) ->> <> {
    <>
}]], { i(1, "name"), i(2), i(3, "()"), i(0, "todo!()") }),
  s("main", "main function", [[fn main() {
    <>
}]], { i(0) }),
  s("struct", "Struct", [[#[derive(Debug)]
struct <> {
    <>: <>,
}]], { i(1, "Name"), i(2, "field"), i(3, "i32") }),
  s("enum", "Enum", [[#[derive(Debug)]
enum <> {
    <>,
}]], { i(1, "Name"), i(2, "Variant") }),
  s("impl", "impl block", [[impl <> {
    <>
}]], { i(1, "Type"), i(0) }),
  s("trait", "Trait", [[trait <> {
    fn <>(&self) ->> <>;
}]], { i(1, "Name"), i(2, "method"), i(3, "()") }),
  s("match", "match expression", [[match <> {
    <> =>> <>,
    _ =>> <>,
}]], { i(1, "value"), i(2, "pattern"), i(3), i(0, "{}") }),
  s("iflet", "if let", [[if let <> = <> {
    <>
}]], { i(1, "Some(x)"), i(2, "value"), i(0) }),
  s("whilelet", "while let", [[while let <> = <> {
    <>
}]], { i(1, "Some(x)"), i(2, "iter.next()"), i(0) }),
  s("test", "Unit test module", [[#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn <>() {
        <>
    }
}]], { i(1, "it_works"), i(0) }),
  s("derive", "derive attribute", [[#[derive(<>)]
<>]], { i(1, "Debug, Clone"), i(0) }),
  s("res", "Result alias", [[type Result<<T>> = std::result::Result<<T, Box<<dyn std::error::Error>>>>;
<>]], { i(0) }),
  s("for", "for loop", [[for <> in <> {
    <>
}]], { i(1, "item"), i(2, "iter"), i(0) }),
  s("iter", "Iterator chain", [[<>.iter()
    .map(|<>| <>)
    .collect::<<Vec<<_>>>>()]], { i(1, "items"), i(2, "x"), i(3, "x") }),
  s("println", "println!", [[println!("<>"<>);]], { i(1, "{}"), i(2) }),
  s("mod", "Module", [[mod <> {
    <>
}]], { i(1, "name"), i(0) }),
})

local i, rep = B.insert, B.rep

B.add("rust", {
  { "derives", "Derive common traits", [[#[derive(Debug, Clone, PartialEq)]
]], {} },
  { "implt", "impl Trait for Type", [[impl <> for <> {
    <>
}]], { i(1, "Trait"), i(2, "Type"), i(0) } },
  { "impld", "impl Display", [[impl std::fmt::Display for <> {
    fn fmt(&self, f: &mut std::fmt::Formatter<<'_>>) ->> std::fmt::Result {
        write!(f, "<>")
    }
}]], { i(1, "Type"), i(0) } },
  { "from", "impl From", [[impl From<<<>>> for <> {
    fn from(v: <>) ->> Self {
        <>
    }
}]], { i(1, "Src"), i(2, "Dst"), rep(1), i(0, "todo!()") } },
  { "tests", "Test module", [[#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn <>() {
        <>
    }
}]], { i(1, "it_works"), i(0) } },
  { "unwrap", "let-else", [[let Some(<>) = <> else {
    <>
};]], { i(1, "x"), i(2, "opt"), i(0, "return;") } },
  { "err", "Error enum with thiserror", [[#[derive(Debug, thiserror::Error)]
enum <> {
    #[error("<>")]
    <>,
}]], { i(1, "Error"), i(2, "message"), i(3, "Variant") } },
  { "closure", "Closure", [[|<>| <>]], { i(1, "x"), i(0) } },
})
