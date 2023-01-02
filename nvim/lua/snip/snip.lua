-- Config snips
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

ls = require("luasnip")
extras = require("luasnip.extras")

snip = ls.snippet
node = ls.snippet_node
text = ls.text_node
insert = ls.insert_node
func = ls.function_node
choice = ls.choice_node
dynamicn = ls.dynamic_node
rep = extras.rep

-- Local functions
fn_recur = function(_, _, _, txt)
    return node(nil, {
        choice(1, {
            text({""}),
            node(nil, {insert(1, txt), dynamicn(2, fn_recur, {}) }),
        })
    });
end

-- Function used by different language snips
fn_myself = function(_, _, _, cmt)
    -- Return a node with my information
    -- Parameters: cmt -> character used for comment (e.g. C: *)
    return node(nil, {
        text({
            cmt .. "@Author: Navarro Torres, Agustín",
            cmt .. "@Email: "}),
        insert(1, "email"),
        dynamicn(2, fn_recur, nil, {user_args = {"email"}})
    });
end

fn_param = function(_, _, _, cmt)
    -- Return a node with to fill parameters and return info
    -- Parameters: cmt -> character used for comment (e.g. C: *)
    
    return node(nil, {
        text({"", cmt, cmt.." @Parameters:", cmt,}),
        insert(1, "param"),
        dynamicn(2, fn_recur, nil, {user_args = {"param"}}),
        text({"", cmt, cmt.." @Return:", cmt,}),
        insert(3, "return"),
        dynamicn(4, fn_recur, nil, {user_args = {"return"}}),
    });
end

-- Load snips for different languages
require('snip/all')
require('snip/sh')
require('snip/c')
require('snip/cpp')
require('snip/python')
require('snip/lua')
require('snip/tex')
require('snip/html')
