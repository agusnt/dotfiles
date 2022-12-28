-- Global snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

-- Auxiliary functions
local date = function() return {os.date('%Y-%m-%d')} end

ls.add_snippets(nil, {
    all =  {
        snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
        }, {
            func(date, {}),
        }),
        snip({
            trig = "myself_g",
            namr = "My-Self without comments",
            dscr = "Information about myself without comments",
        }, {
            text({
                    "@Author: Navarro Torres, Agustín", 
                    "@Email: agusnavarro11@gmail.com, agusnt@unizar.es"
                 }),
        }),
    },
})
