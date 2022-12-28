-- Sh snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls.add_snippets(nil, {
    sh = {
        snip({
            trig = "myself",
            namr = "My-Self",
            dscr = "Information about myself",
        }, {
            text({
                    "# @Author: Navarro Torres, Agustín",
                    "# @Email: agusnavarro11@gmail.com, agusnt@unizar.es"
                 }),
        }),
    },
})
