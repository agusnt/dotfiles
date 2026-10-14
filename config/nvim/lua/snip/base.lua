-- Shared LuaSnip nodes and helper functions (required by every snip/<lang>.lua)
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local ls = require("luasnip")
local extras = require("luasnip.extras")

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local rep = extras.rep

-- Local functions
local fn_recur
fn_recur = function(_, _, _, txt)
    return node(nil, {
        choice(1, {
            text({""}),
            node(nil, {
                insert(1, txt),
                dynamicn(2, fn_recur, {})
            }),
        })
    });
end

local fn_recur_2
fn_recur_2 = function(_, _, _, txt, ins)
    return node(nil, {
        choice(1, {
            text({""}),
            node(nil, {
                text(txt),
                insert(1, ins),
                dynamicn(2, fn_recur_2, {}, {user_args = {txt, ins}})
            }),
        })
    });
end

local fn_recur_3
fn_recur_3 = function(_, _, _, txt, ins)
    return node(nil, {
        choice(1, {
            text({""}),
            node(nil, {
                text({"", txt}),
                insert(1, ins),
                dynamicn(2, fn_recur_3, {}, {user_args = {txt, ins}})
            }),
        })
    });
end

-- Function used by different language snips
local fn_myself = function(_, _, _, cmt)
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

local fn_param = function(_, _, _, cmt)
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

-- Add snippets written with fmta (<> = placeholder, << and >> = literal angle brackets):
-- B.add("lua", { { "trig", "Description", [[template]], { nodes... } }, ... })
local function add(ft, list)
  local fmta = require("luasnip.extras.fmt").fmta
  local out = {}
  for _, e in ipairs(list) do
    out[#out + 1] = snip({ trig = e[1], namr = e[2], dscr = e[2] }, fmta(e[3], e[4] or {}))
  end
  ls.add_snippets(ft, out)
end

return {
  add = add,
  ls = ls, extras = extras, snip = snip, node = node, text = text, insert = insert,
  func = func, choice = choice, dynamicn = dynamicn, rep = rep,
  fn_recur = fn_recur, fn_recur_2 = fn_recur_2, fn_recur_3 = fn_recur_3,
  fn_myself = fn_myself, fn_param = fn_param,
}
