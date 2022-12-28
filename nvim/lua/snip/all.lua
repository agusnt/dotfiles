-- Global snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

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
