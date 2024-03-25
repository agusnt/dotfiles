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

-- Functions for configure the dap
function AskArgs()
    local askPerson = function()
        local argument_string = vim.fn.input('Program arguments: ')
        local bar = vim.fn.split(argument_string, " ", true)
        if bar[1] == '' then
            return nil
        end
        return bar
    end

    -- Depend on the file format
    if vim.bo.filetype == 'python' then
        require('dap').configurations.python = {
            {
                type = 'python',
                request = 'launch',
                program = '${file}',
                args = askPerson
            }
        }
    end
    require('dap').continue()
end
