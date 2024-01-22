-- Status line options
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

local function statusline()
    local fname = "%#Normal# (%l:%c) %f %y %m %r"
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")

    if string.len(branch) > 0 then
        branch = " " .. branch
    end
    return "%=" .. fname .. branch .. "%="
end

vim.opt.statusline = statusline()
