-- CPP snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls.add_snippets(nil, {
    cpp = {
        snip({
            trig = "myself_o",
            namr = "My-Self One line",
            dscr = "Information about myself for one line comments",
        }, {
            text({
                    "# @Author: Navarro Torres, Agustín", 
                    "# @Email: agusnavarro11@gmail.com, agusnt@unizar.es"
                 }),
        }),
        snip({
            trig = "myself",
            namr = "My-Self",
            dscr = "Information about myself for multi line comments",
        }, {
            text({
                    "* @Author: Navarro Torres, Agustín", 
                    "* @Email: agusnavarro11@gmail.com, agusnt@unizar.es"
                 }),
        }),
    },
})
