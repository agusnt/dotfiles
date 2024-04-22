-- Auxiliary function used in different configuration files
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

function Map(mode, lhs, rhs, opts)
    --[[
    Map keys to functions

    Parameters:
        mode : Vim modes (Normal/Insert/Visual)
        lhs  : keybinds
        rhs  : commands
        opts : additional options like <silent>/<noremap>
    --]]
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function Lspmap(mode, lhs, rhs)
  --[[
    Map keys to functions

    Parameters:
        mode : Vim modes (Normal/Insert/Visual)
        lhs  : keybinds
        rhs  : commands
    --]]
    local opts = {buffer = true}
    vim.keymap.set(mode, lhs, rhs, opts)
end
