-- LuaLine
-- @Author: Navarro Torres, Agustín
-- @Email: agusnavarro11@gmail.com

require('lualine').setup{options =
    {
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        sections =
        {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
        },
        theme = 'gruvbox-material'
    },
}
