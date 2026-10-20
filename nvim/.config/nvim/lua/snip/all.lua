-- Global snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local B = require("snip/base")
local ls, snip, text, func, dynamicn, fn_myself = B.ls, B.snip, B.text, B.func, B.dynamicn, B.fn_myself

-- Auxiliary functions
local date = function() return {os.date('%Y-%m-%d')} end

ls.add_snippets("all", {
    snip({
        trig = "date",
        namr = "Date",
        dscr = "Date in the form of YYYY-MM-DD",
    }, {
        func(date, {}),
    }),

    snip({
        trig = "myself",
        namr = "My-Self without comments",
        dscr = "Information about myself without comments",
    }, {
        dynamicn(1, fn_myself, nil, {user_args = { "" }})
    }),

    snip({
        trig = "unizar",
        namr = "Unizar email",
        dscr = "Print unizar email",
    }, {
        text({"agunst@unizar.es"}),
    }),

    snip({
        trig = "gmail",
        namr = "GMail",
        dscr = "Print gmail",
    }, {
        text({"agusnavarro11@gmail.com"}),
    }),
})

-- Comment-tag snippets (todo-comments picks these keywords up)
require("snip/base").add("all", {
  { "todo", "TODO comment", [[TODO: <>]], { require("snip/base").insert(1) } },
  { "fixme", "FIXME comment", [[FIXME: <>]], { require("snip/base").insert(1) } },
  { "note", "NOTE comment", [[NOTE: <>]], { require("snip/base").insert(1) } },
})
