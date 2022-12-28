-- Lua snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls.add_snippets(nil, {
    lua = {
        snip({
            trig = "myself_o",
            namr = "My-Self One line",
            dscr = "Information about myself for one line comments",
        }, {
            text({
                    "-- @Author: Navarro Torres, Agustín",
                    "-- @Email: agusnavarro11@gmail.com, agusnt@unizar.es"
                 }),
        }),
    },
})
