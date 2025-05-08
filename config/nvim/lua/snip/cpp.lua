-- CPP snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

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
